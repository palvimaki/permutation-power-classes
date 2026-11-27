"""Independent exact packing counts and poset checks. Run with Python 3."""

from functools import lru_cache
from itertools import combinations, permutations


def packing_count(pattern, overlap, copies):
    length = len(pattern)
    step = length - overlap
    size = length + (copies - 1) * step
    rank_order = sorted(range(length), key=pattern.__getitem__)
    predecessors = [0] * size
    for copy in range(copies):
        positions = [copy * step + i for i in rank_order]
        for lower, upper in zip(positions, positions[1:]):
            predecessors[upper] |= 1 << lower

    @lru_cache(None)
    def count(placed):
        if placed == (1 << size) - 1:
            return 1
        total = 0
        for position, required in enumerate(predecessors):
            bit = 1 << position
            if not (placed & bit) and (required & placed) == required:
                total += count(placed | bit)
        return total

    return count(0)


def pattern_with_ends(prefix, suffix):
    used = set(prefix + suffix)
    middle = [rank for rank in range(1, suffix[-1] + 1) if rank not in used]
    return prefix + middle + suffix


for prefix, suffix, base in [
    ([1, 2], [3, 5], 1),
    ([1, 3], [4, 6], 2),
    ([1, 4], [5, 7], 3),
    ([1, 5, 6], [7, 9, 10], 4),
    ([1, 3, 6], [7, 10, 13], 18),
]:
    pattern = pattern_with_ends(prefix, suffix)
    counts = [packing_count(pattern, len(prefix), j) for j in range(1, 5)]
    assert counts == [base**n for n in range(4)]
    print(base, counts)

pattern = (1, 4, 2, 3, 6, 5, 7)
labels = tuple(range(1, 13))
matches = []
for chosen in combinations(labels, len(pattern)):
    first = tuple(chosen[rank - 1] for rank in pattern)
    unused = [x for x in labels if x not in chosen]
    for tail in permutations(unused):
        second = first[-2:] + tail
        ranks = {x: i for i, x in enumerate(sorted(second), 1)}
        if tuple(ranks[x] for x in second) == pattern:
            matches.append(first + tail)
assert len(matches) == 3
for match in matches:
    print(*match)


from math import comb, prod


def rank_test(pattern, overlap):
    length = len(pattern)
    prefix = pattern[:overlap]
    suffix = pattern[-overlap:]
    p = sorted(prefix)
    q = sorted(suffix)
    if [p.index(v) for v in prefix] != [q.index(v) for v in suffix]:
        return None
    a = [0, *p, length + 1]
    c = [0, *q, length + 1]
    gaps = [(a[i+1]-a[i]-1, c[i+1]-c[i]-1) for i in range(overlap+1)]
    base = prod(comb(left + right, left) for left, right in gaps)
    ranks = set(range(1, length + 1))
    incoming = ranks.difference(p)
    bounds = [(x, x) for x in ranks.difference(q)]
    for distance in range(1, overlap + 2):
        bounds = [
            (max((v for v, w in zip(p, q) if w <= lower), default=0),
             min((v for v, w in zip(p, q) if w >= upper), default=length+1))
            for lower, upper in bounds
        ]
        if distance >= 2 and any(lo < y < hi for lo, hi in bounds for y in incoming):
            return base, distance
    return base, None


def check_blocks(pattern, overlap, copies):
    length = len(pattern)
    step = length - overlap
    size = length + (copies - 1) * step
    positions = sorted(range(length), key=pattern.__getitem__)
    below = [set() for _ in range(size)]
    for window in range(copies):
        chain = [window * step + pos for pos in positions]
        for i, vertex in enumerate(chain):
            below[vertex].update(chain[:i])
    for pivot in range(size):
        for lower_set in below:
            if pivot in lower_set:
                lower_set.update(below[pivot])

    p = [0, *sorted(pattern[:overlap]), length + 1]
    q = [0, *sorted(pattern[-overlap:]), length + 1]
    blocks = set()
    edges = set()
    for window in range(copies - 1):
        for gap in range(overlap + 1):
            left = [window * step + positions[r-1] for r in range(q[gap]+1, q[gap+1])]
            right = [(window+1) * step + positions[r-1] for r in range(p[gap]+1, p[gap+1])]
            if left and right:
                vertices = set(left + right)
                assert blocks.isdisjoint(vertices)
                blocks.update(vertices)
                edges.update(tuple(sorted((u, v))) for u in left for v in right)
    actual = {(u, v) for u in range(size) for v in range(u+1, size)
              if u not in below[v] and v not in below[u]}
    assert actual == edges, (pattern, overlap, copies)


pairs = 0
checks = 0
structure_checks = 0
for length in range(2, 7):
    for pattern in permutations(range(1, length+1)):
        for overlap in range(1, length):
            result = rank_test(pattern, overlap)
            if result is None:
                assert packing_count(pattern, overlap, 2) == 0
                continue
            base, failure = result
            pairs += 1
            for copies in range(2, overlap+4):
                actual = packing_count(pattern, overlap, copies)
                expected = base ** (copies-1)
                if failure is None or copies <= failure:
                    assert actual == expected, (pattern, overlap, copies)
                    check_blocks(pattern, overlap, copies)
                    structure_checks += 1
                else:
                    assert actual > expected, (pattern, overlap, copies)
                checks += 1
print("Pairs, counts, and block checks:", pairs, checks, structure_checks)

pattern = (1, 2, 3, 5, 8, 4, 6, 7, 9)
assert rank_test(pattern, 4) == (2, None)
assert [packing_count(pattern, 4, j) for j in range(1, 8)] == [1, 2, 4, 8, 16, 32, 64]
assert rank_test((1, 3, 2, 4), 2) == (2, 2)
assert packing_count((1, 3, 2, 4), 2, 3) == 5

large_pairs = large_counts = large_blocks = 0
for pattern in permutations(range(1, 8)):
    for overlap in (4, 5, 6):
        result = rank_test(pattern, overlap)
        if result is None:
            continue
        base, failure = result
        large_pairs += 1
        for copies in range(2, overlap + 4):
            actual = packing_count(pattern, overlap, copies)
            power = base ** (copies - 1)
            if failure is None or copies <= failure:
                assert actual == power, (pattern, overlap, copies)
                check_blocks(pattern, overlap, copies)
                large_blocks += 1
            else:
                assert actual > power, (pattern, overlap, copies)
            large_counts += 1
assert large_pairs == 172
print("Length seven, large overlaps: pairs, counts, blocks", large_pairs, large_counts, large_blocks)


def delay_pattern(length):
    shift = length - 2
    keys = [3 * i + track * (3 * shift + 1) for i in range(length) for track in range(3)]
    ranks = {key: rank for rank, key in enumerate(sorted(keys), 1)}
    return tuple(ranks[key] for key in keys)


for length in range(5, 16):
    pattern = delay_pattern(length)
    overlap = 3 * length - 3
    assert rank_test(pattern, overlap) == (1, length - 2)
    for copies in range(1, length + 4):
        actual = packing_count(pattern, overlap, copies)
        assert actual == 2 ** max(0, copies - length + 2)
print("Delayed family: 11 pattern lengths from 15 through 45 passed.")
pattern = delay_pattern(7)
print("Length 21, overlap 18:", pattern)
print("Counts for copies 1 through 8:", [packing_count(pattern, 18, j) for j in range(1, 9)])


def inflated_delay(length, base, keep_delay):
    entries = []
    for i in range(length):
        for track, offset in enumerate((0, 4, 3 * (length - 1) + 2)):
            width = base - 1 if track == 0 else 1
            entries.extend((0, -(3 * i + offset), copy) for copy in range(width))
        for track in range(3):
            key = 3 * i + track * (3 * (length - 2) + 1) if keep_delay else 3 * i + track
            entries.append((1, key, 0))
    ranks = {value: rank for rank, value in enumerate(sorted(entries), 1)}
    return tuple(ranks[entry] for entry in entries)


for length in (5, 6, 7):
    for base in (2, 3, 5):
        overlap = (base + 4) * (length - 1)
        for delay in (False, True):
            pattern = inflated_delay(length, base, delay)
            for copies in range(1, length + 2):
                additional = max(0, copies - length + 2) if delay else 0
                assert packing_count(pattern, overlap, copies) == base ** (copies - 1) * 2 ** additional
print("Inflated and baseline families passed for bases 2, 3, 5 and L = 5, 6, 7.")
assert [packing_count((1, 3, 2), 1, j) for j in (2, 3)] == [3, 15]
