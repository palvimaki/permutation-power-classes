"""Check the Catalan and ternary criteria against counts from physical windows."""
from collections import Counter
from functools import lru_cache
from itertools import groupby, permutations
from math import comb
import json

from growth_check import count_extensions, predecessors


def standardize(word):
    ranks = {v: i for i, v in enumerate(sorted(word))}
    return tuple(ranks[v] for v in word)


def components(pattern, overlap):
    stride = len(pattern) - overlap
    offsets = sorted(range(len(pattern)), key=pattern.__getitem__)
    last = {x % stride: i for i, x in enumerate(offsets)}
    start = end = 0
    for i, x in enumerate(offsets):
        end = max(end, last[x % stride])
        if i != end:
            continue
        block = sorted(offsets[start:i + 1])
        width = len({a % stride for a in block})
        shared = next((a for a in block if a + stride < len(pattern)), None)
        direction = 0 if shared is None else (1 if pattern[shared] < pattern[shared + stride] else -1)
        yield direction, width, standardize([pattern[a] for a in block])
        start = i + 1


@lru_cache(None)
def is_always_chain(pattern, stride):
    overlap = len(pattern) - stride
    # The base-one cutoff only needs uniqueness. Stop at the first choice.
    below = predecessors(pattern, overlap, max(3, overlap + 1))
    left = (1 << len(below)) - 1
    while left:
        ready = [i for i, pred in enumerate(below) if left & (1 << i) and not pred & left]
        if len(ready) != 1:
            return False
        left ^= 1 << ready[0]
    return True


@lru_cache(None)
def two_copy_count(pattern, overlap):
    return count_extensions(predecessors(pattern, overlap, 2))


def classify(pattern, overlap):
    runs = []
    for direction, group in groupby(components(pattern, overlap), key=lambda item: item[0]):
        group = list(group)
        if not direction or any(not is_always_chain(p, w) for _, w, p in group):
            return 0
        if len(group) > 1:
            runs.append(sorted(w for _, w, _ in group))
    if runs == [[1, 1]]:
        return 2
    if runs == [[1, 2]]:
        return 3 if two_copy_count(pattern, overlap) == 3 else -3
    return 0


def census(k):
    stats = Counter()
    for pattern in permutations(range(k)):
        for m in range(1, k):
            if standardize(pattern[:m]) != standardize(pattern[-m:]):
                continue
            stats['pairs'] += 1
            label = classify(pattern, m)
            n2 = two_copy_count(pattern, m)
            if label:
                stats[{2: 'catalan', 3: 'ternary', -3: 'same_rate_other'}[label]] += 1
            # Reject other pairs immediately when their two-copy count differs.
            for order in (2, 3):
                if n2 != order:
                    assert label != order
                    continue
                witness = None
                for j in range(3, 7):
                    value = count_extensions(predecessors(pattern, m, j))
                    if value != comb(order * j, j) // ((order - 1) * j + 1):
                        witness = j
                        break
                if label == order:
                    assert witness is None
                elif witness is None:
                    stats['prefix_only_matches'] += 1
    return dict(K=k, **stats)


if __name__ == '__main__':
    import sys
    for length in map(int, sys.argv[1:]):
        print(json.dumps(census(length)), flush=True)
