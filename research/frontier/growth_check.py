"""Recompute small packing counts from physical inequalities and test the growth statements."""
from collections import Counter
from functools import lru_cache
from itertools import permutations
from math import comb, factorial
import json


def rank_invariants(pattern, overlap):
    stride = len(pattern) - overlap
    covered = set()
    for a in range(overlap):
        lo, hi = sorted((pattern[a], pattern[a + stride]))
        covered.update(range(lo, hi + 1))
    rank_order = sorted(range(len(pattern)), key=pattern.__getitem__)
    word = [a % stride for a in rank_order]
    last = {letter: i for i, letter in enumerate(word)}
    runs = []
    start = 0
    end = 0
    for i, letter in enumerate(word):
        end = max(end, last[letter])
        if i == end:
            block = rank_order[start:i + 1]
            repeated = [x for x in block if x + stride < len(pattern)]
            direction = 0
            if repeated:
                x = repeated[0]
                direction = 1 if pattern[x] < pattern[x + stride] else -1
            runs.append(direction)
            start = i + 1
    free = len(pattern) - len(covered)
    assert free == runs.count(0)
    finite = free == 0 and all(a != b for a, b in zip(runs, runs[1:]))
    return free, finite


def predecessors(pattern, overlap, copies):
    k = len(pattern)
    stride = k - overlap
    n = copies * stride + overlap
    below = [0] * n
    for i in range(copies):
        start = i * stride
        for a in range(k):
            for b in range(k):
                if pattern[a] < pattern[b]:
                    below[start + b] |= 1 << (start + a)
    return below


def direct_infinite_test(pattern, overlap):
    distance = overlap + 1
    below = predecessors(pattern, overlap, distance + 1)
    for a in range(len(below)):
        for b, pred in enumerate(below):
            if pred & (1 << a):
                below[b] |= below[a]
    stride = len(pattern) - overlap
    return any(not (below[b] & (1 << a) or below[a] & (1 << b))
               for a in range(stride) for b in range(distance * stride + overlap, len(below)))


def count_extensions(below):
    @lru_cache(None)
    def visit(left):
        if not left:
            return 1
        return sum(visit(left ^ (1 << a)) for a, pred in enumerate(below)
                   if left & (1 << a) and not left & pred)
    return visit((1 << len(below)) - 1)


def check(k):
    result = Counter()
    for p in permutations(range(k)):
        for m in range(1, k):
            d = k - m
            if any((p[a] < p[b]) != (p[a+d] < p[b+d]) for a in range(m) for b in range(a)):
                continue
            s, finite = rank_invariants(p, m)
            assert finite != direct_infinite_test(p, m)
            result['pairs'] += 1
            result['finite'] += int(finite)
            result['infinite'] += int(not finite)
            for j in range(1, 5):
                n = count_extensions(predecessors(p, m, j))
                assert factorial(j)**s <= n <= factorial(j)**s * d**(j*d+m)
                if not finite:
                    assert n >= comb(2*j, j) // (j+1)
                result['counts'] += 1
    return dict(K=k, **result)


if __name__ == '__main__':
    for length in range(2, 7):
        print(json.dumps(check(length)), flush=True)
