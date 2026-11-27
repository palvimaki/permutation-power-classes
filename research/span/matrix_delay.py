"""Compute exact delays inside the finite-span census. Input is matrix-data.jsonl."""
import argparse
import json
from collections import defaultdict


def sequence(row, upto):
    start = row['start']
    if start not in (1, 2):
        raise ValueError("earlier boundary terms required for this input")
    terms = [1] if start == 2 else []
    vector = [1] * len(row['states'])
    for _ in range(start, upto + 1):
        terms.append(sum(vector))
        new = [0] * len(vector)
        for i, j, weight in row['entries']:
            new[i] += weight * vector[j]
        vector = new
    return tuple(terms)


def describe(row):
    return [row['representative'], row['overlap']]


def evaluate(rows, upto):
    last = None
    examples = []
    sequences = [sequence(row, upto) for row in rows]
    by_prefix = {(): list(range(len(rows)))}
    for t in range(upto):
        refined = {}
        for prefix, indices in by_prefix.items():
            groups = defaultdict(list)
            for i in indices:
                groups[sequences[i][t]].append(i)
            if len(groups) > 1:
                last = t + 1
                a, b = list(groups.values())[:2]
                examples = [describe(rows[a[0]]), describe(rows[b[0]])]
            for value, members in groups.items():
                refined[prefix + (value,)] = members
        by_prefix = refined
    return len(by_prefix), last, examples


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('data')
    args = parser.parse_args()
    with open(args.data) as f:
        data = [json.loads(s) for s in f]
    for k in sorted({r['K'] for r in data}):
        rows = [r for r in data if r['K'] <= k]
        # Common onset plus a bound on the annihilator order of every difference.
        upto = max(r['start'] for r in rows) + 2 * max(len(r['recurrence']) for r in rows) - 1
        classes, delay, witnesses = evaluate(rows, upto)
        print(json.dumps(dict(max_K=k, cutoff_used=upto, wilf_classes=classes,
                              max_first_disagreement=delay, witness_patterns_and_overlaps=witnesses)))


if __name__ == '__main__':
    main()
