"""Compare words under the threshold boundary with literal packing posets."""
from collections import Counter
from itertools import combinations_with_replacement
import json

from growth_check import count_extensions, predecessors


def pattern_from_keys(keys):
    ranks = {k: i for i, k in enumerate(sorted(keys))}
    return tuple(ranks[k] for k in keys)


def construct(thresholds):
    phases = (0, *thresholds)
    r = len(phases)
    keys = []
    for u in range(max(phases) + 2):
        keys.append((0, u))
        keys.extend((1, r * (u + t) + h) for h, t in enumerate(phases))
    return pattern_from_keys(keys), len(keys) - r - 1


def shortest_ternary(t):
    if t == 0:
        return (3, 1, 4, 5, 2), 2
    keys = []
    for u in range(t + 1):
        keys.extend(((1, 2*u), (0, u), (1, 2*(u+t)+1)))
    keys.append((1, 2*t+2))
    return pattern_from_keys(keys), len(keys) - 3


def paths(thresholds, j):
    old = [1]
    for a in range(1, j + 1):
        limit = a + sum(max(0, a-t) for t in thresholds)
        new = [0] * (limit+1)
        for b in range(limit+1):
            if b < len(old):
                new[b] += old[b]
            if b:
                new[b] += new[b-1]
        old = new
    return old[-1]


if __name__ == '__main__':
    stats = Counter()
    for r in range(1, 6):
        for ts in combinations_with_replacement(range(3), r-1):
            pattern, overlap = construct(ts)
            stats['constructions'] += 1
            for j in range(1, 8):
                assert paths(ts, j) == count_extensions(predecessors(pattern, overlap, j))
                stats['counts'] += 1
    for t in range(8):
        pattern, overlap = shortest_ternary(t)
        assert len(pattern) == (3*t+4 if t else 5)
        for j in range(1, 11):
            assert paths((t,), j) == count_extensions(predecessors(pattern, overlap, j))
            stats['minimal_witness_counts'] += 1
        if t:
            assert next(j for j in range(1, t+3) if paths((t,), j) != paths((t-1,), j)) == t+1
    print(json.dumps(stats))
