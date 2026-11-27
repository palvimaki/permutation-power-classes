"""Compare all admissible pairs of lengths two through five at two and three copies."""

from collections import defaultdict
from functools import lru_cache
from itertools import combinations, permutations
from math import comb, prod


def literal_counts(pattern, overlap, copy_counts=(2, 3)):
    """Count topological sorts of the prescribed physical window chains."""
    k = len(pattern)
    d = k - overlap
    counts = []
    for copies in copy_counts:
        n = k + (copies - 1) * d
        prerequisites = [0] * n
        for i in range(copies):
            for a in range(k):
                for b in range(k):
                    if pattern[a] < pattern[b]:
                        prerequisites[i*d+b] |= 1 << (i*d+a)

        @lru_cache(None)
        def visit(placed):
            if placed == (1 << n) - 1:
                return 1
            return sum(visit(placed | 1 << v) for v in range(n)
                       if not placed & 1 << v and not prerequisites[v] & ~placed)

        counts.append(visit(0))
    return tuple(counts)


def merged_counts(pattern, overlap):
    """Enumerate each first two-window rank word. Count its last-window interleavings."""
    k = len(pattern)
    d = k - overlap
    first = tuple(sorted(range(k), key=pattern.__getitem__))
    second = tuple(v+d for v in first)
    third = tuple(v+2*d for v in first)
    n = k+d
    new = tuple(v for v in second if v >= k)
    words = 0
    extensions = 0
    for old_places in combinations(range(n), k):
        old_places = set(old_places)
        old_iter, new_iter = iter(first), iter(new)
        word = tuple(next(old_iter) if i in old_places else next(new_iter) for i in range(n))
        if tuple(v for v in word if v >= d) != second:
            continue
        words += 1
        shared = tuple(v for v in third if v < n)
        old_marks = (-1,) + tuple(word.index(v) for v in shared) + (n,)
        new_marks = (-1,) + tuple(third.index(v) for v in shared) + (k,)
        extensions += prod(comb(b-a+e-c-2, b-a-1)
                           for a, b, c, e in zip(old_marks, old_marks[1:], new_marks, new_marks[1:]))
    return words, extensions


def orbit(pattern, overlap):
    """Signature of the chain gluing, up to reversing time and all inequalities."""
    k = len(pattern)
    p = tuple(sorted(pattern[:overlap]))
    q = tuple(sorted(pattern[-overlap:]))
    cp = tuple(sorted(k+1-v for v in p))
    cq = tuple(sorted(k+1-v for v in q))
    return k, min((p, q), (q, p), (cp, cq), (cq, cp))


def study():
    all_counts = defaultdict(lambda: defaultdict(dict))
    for k in range(2, 6):
        for pattern in permutations(range(1, k+1)):
            for m in range(1, k):
                # A cycle in the literal poset prevents extensions.
                actual = literal_counts(pattern, m)
                left_order = sorted(range(m), key=pattern[:m].__getitem__)
                right_order = sorted(range(m), key=pattern[-m:].__getitem__)
                assert bool(actual[0]) == (left_order == right_order)
                if not actual[0]:
                    assert actual[1] == 0
                    continue
                if actual == (1, 1):
                    # The base paper's Theorem 1 promotes this check to all copy counts.
                    assert literal_counts(pattern, m, (m+2,)) == (1,)
                expected = merged_counts(pattern, m)
                assert actual == expected, (pattern, m, actual, expected)
                all_counts[k][actual].setdefault(orbit(pattern, m), (pattern, m))
    return all_counts


if __name__ == '__main__':
    for k, by_count in sorted(study().items()):
        print(f'K={k}')
        for (n2,n3), signatures in sorted(by_count.items()):
            representatives = [''.join(map(str, p)) + '/' + str(m) for p, m in signatures.values()]
            print(f'  {n2},{n3}  ' + ' '.join(sorted(representatives)))
