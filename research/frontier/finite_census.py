"""Classify finite-span tails and test the transfer matrix row sums. Python 3.9+."""
import argparse
from collections import Counter, defaultdict
from fractions import Fraction
from itertools import combinations
import json
from math import factorial, prod
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "span"))
from matrix_census import finite_span, model, recurrence, terms
from matrix_replay import literal_count


def representatives(k, m):
    """Realize each prefix/suffix rank signature from its physical residue paths."""
    stride = k - m
    ranks = range(1, k + 1)
    physical = [tuple(range(a, k, stride)) for a in range(stride)]
    sizes = sorted(map(len, physical))
    multiplicity = prod(factorial(n) for n in Counter(sizes).values())
    subsets = list(combinations(ranks, m))
    for prefix in subsets:
        for suffix in subsets:
            if any(x == y for x, y in zip(prefix, suffix)):
                continue
            successor = dict(zip(prefix, suffix))
            paths = defaultdict(list)
            for x in ranks:
                if x in suffix:
                    continue
                path = [x]
                while path[-1] in successor:
                    path.append(successor[path[-1]])
                paths[len(path)].append(path)
            actual = sorted(length for length, items in paths.items() for _ in items)
            if actual != sizes:
                continue
            pattern = [0] * k
            for track in physical:
                path = paths[len(track)].pop()
                for a, x in zip(track, path):
                    pattern[a] = x
            yield prefix, suffix, tuple(pattern), multiplicity


def analyze(k, m, prefix, suffix, pattern, span):
    r, states, entries = model(pattern, prefix, suffix, span)
    dim = len(states)
    row_sums = [0] * dim
    for a, _, weight in entries:
        row_sums[a] += weight
    next_row = [0] * dim
    for a, b, weight in entries:
        next_row[a] += weight * row_sums[b]
    assert min(row_sums) > 0
    eigen = all(v * row_sums[0] == next_row[0] * u for u, v in zip(row_sums, next_row))
    # Cayley-Hamilton bounds the minimal scalar recurrence order by dim.
    seq = terms(states, entries, max(3 * dim, 6))
    coeffs = recurrence(seq, dim)
    reduced = coeffs[:]
    while reduced and reduced[-1] == 0:
        reduced.pop()
    # Division of the minimal polynomial by its full power of X removes transient terms.
    geometric = len(reduced) == 1
    initial = [literal_count(pattern, m, j) for j in range(1, r)]
    onset = None
    if geometric:
        ratio = reduced[0]
        all_terms = initial + seq
        onset = 1 + max((j for j in range(1, len(all_terms))
                         if all_terms[j] != ratio * all_terms[j - 1]), default=0)
        assert onset <= r + len(coeffs) - 1
    else:
        assert not eigen
    record = dict(overlap=m, prefix=prefix, suffix=suffix, pattern=pattern,
                  span=span, dimension=dim, minimal_recurrence=list(map(str, coeffs)),
                  eventual_recurrence=list(map(str, reduced)), row_sum_is_eigenvector=eigen,
                  onset=onset, first_counts=(initial + seq)[:9])
    if not eigen or not geometric:
        record.update(row_sums=row_sums, next_row=next_row, entries=entries)
    return record


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("length", type=int, nargs="+")
    args = parser.parse_args()
    for k in args.length:
        counts = Counter()
        spans, onset_hist, dim_hist, eventual_orders = (Counter() for _ in range(4))
        examples = {}
        for m in range(1, k):
            for p, q, pattern, multiplicity in representatives(k, m):
                counts["admissible_pairs"] += multiplicity
                counts["admissible_signatures"] += 1
                span = finite_span(k, p, q)
                if span is None:
                    continue
                a = analyze(k, m, p, q, pattern, span)
                counts["finite_pairs"] += multiplicity
                counts["finite_signatures"] += 1
                spans[span] += multiplicity
                dim_hist[a["dimension"]] += multiplicity
                eventual_orders[len(a["eventual_recurrence"])] += multiplicity
                if a["onset"] is not None:
                    onset_hist[a["onset"]] += multiplicity
                if not a["row_sum_is_eigenvector"]:
                    counts["failed_eigen_pairs"] += multiplicity
                    counts["failed_eigen_signatures"] += 1
                if a["onset"] is None:
                    counts["nongeometric_pairs"] += multiplicity
                    counts["nongeometric_signatures"] += 1
                key = (a["row_sum_is_eigenvector"], tuple(a["minimal_recurrence"]), a["onset"])
                examples.setdefault(key, a)
            print(f"K={k} overlap={m} done", file=sys.stderr, flush=True)
        for field in ("failed_eigen_pairs", "failed_eigen_signatures",
                      "nongeometric_pairs", "nongeometric_signatures"):
            counts.setdefault(field, 0)
        print(json.dumps(dict(K=k, **counts, spans=spans, dimensions=dim_hist,
                              onsets=onset_hist, eventual_orders=eventual_orders,
                              examples=list(examples.values())), separators=(",", ":")), flush=True)


if __name__ == "__main__":
    main()
