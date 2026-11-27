"""Check every finite pair against the stored transfer data. Run with the JSONL file path."""
import argparse
from collections import Counter
from functools import lru_cache
from itertools import permutations
import json


def literal_count(pattern, overlap, j, fixed_orders=()):
    """Partition all linear extensions by their last physical position."""
    k = len(pattern)
    stride = k - overlap
    n = k + (j - 1) * stride
    above = [0] * n
    for start in range(0, n - k + 1, stride):
        for i in range(k):
            for h in range(k):
                if pattern[i] < pattern[h]:
                    above[start + i] |= 1 << (start + h)

    for order in fixed_orders:
        for i, v in enumerate(order):
            for w in order[i + 1:]:
                above[v] |= 1 << w

    @lru_cache(None)
    def delete_max(remaining):
        if remaining == 0:
            return 1
        count = 0
        bits = remaining
        while bits:
            last = bits & -bits
            bits ^= last
            if above[last.bit_length() - 1] & remaining == 0:
                count += delete_max(remaining ^ last)
        return count

    result = delete_max((1 << n) - 1)
    delete_max.cache_clear()
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('data')
    args = parser.parse_args()
    with open(args.data) as f:
        rows = [json.loads(line) for line in f]
    data = {(a['K'], tuple(a['prefix']), tuple(a['suffix'])): a for a in rows}
    if len(data) != len(rows):
        raise ValueError("duplicate matrix records")
    multiplicities = Counter()
    for k in sorted({key[0] for key in data}):
        counts = pairs = entries_checked = 0
        for row in (row for row in rows if row['K'] == k):
            stride = k - row['overlap']
            sample, states, r = row['representative'], row['states'], row['start']
            dimensions = k + (r - 1) * stride
            if len({tuple(s) for s in states}) != len(states):
                raise ValueError("duplicate states")
            for state in states:
                if sorted(state) != list(range(dimensions)):
                    raise ValueError("state omits or repeats a position")
                if literal_count(sample, row['overlap'], r, [state]) != 1:
                    raise ValueError("state violates a window")
            if literal_count(sample, row['overlap'], r) != len(states):
                raise ValueError("incomplete state list")
            weights = {(a, b): w for a, b, w in row['entries']}
            for a, prefix in enumerate(states):
                for b, suffix in enumerate(states):
                    constraints = [prefix, [stride + i for i in suffix]]
                    multiplicity = literal_count(sample, row['overlap'], r + 1, constraints)
                    if multiplicity != weights.get((a, b), 0):
                        raise ValueError((sample, row['overlap'], a, b, multiplicity))
                    entries_checked += 1
        for pattern in permutations(range(1, k + 1)):
            for m in range(1, k):
                stride = k - m
                if any((pattern[h] < pattern[i]) != (pattern[stride+h] < pattern[stride+i])
                       for i in range(m) for h in range(i)):
                    continue
                key = k, tuple(sorted(pattern[:m])), tuple(sorted(pattern[-m:]))
                if key not in data:
                    continue
                pairs += 1
                row = data[key]
                multiplicities[key] += 1
                for t, prediction in enumerate(row['tail'], row['start']):
                    actual = literal_count(pattern, m, t)
                    if actual != prediction:
                        raise ValueError((pattern, m, t, actual, prediction))
                    counts += 1
        print(json.dumps(dict(K=k, finite_pairs_replayed=pairs, literal_counts_compared=counts, matrix_entries_checked=entries_checked)), flush=True)
    if any(multiplicities[key] != row['multiplicity'] for key, row in data.items()):
        raise ValueError("multiplicity mismatch")


if __name__ == '__main__':
    main()
