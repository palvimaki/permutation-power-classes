"""Verify all counterexample recurrences from physical positions and integer certificates."""
from collections import Counter
from functools import lru_cache
import json
import sys


def extensions(pattern, m, copies):
    """Delete maxima; append each deleted position to an order of the remainder."""
    k = len(pattern)
    step = k - m
    n = k + (copies - 1) * step
    successors = [set() for _ in range(n)]
    for t in range(copies):
        base = t * step
        for a, rank in enumerate(pattern):
            successors[base+a].update(base+b for b, value in enumerate(pattern) if rank < value)

    @lru_cache(None)
    def orders(left):
        if not left:
            return ((),)
        result = []
        for x in left:
            if successors[x].isdisjoint(left):
                result.extend(order + (x,) for order in orders(left - {x}))
        return tuple(result)

    return orders(frozenset(range(n)))


def quotient(pattern, m, r):
    """Recover an equitable partition by counting outgoing edges to its cells."""
    k = len(pattern)
    step = k - m
    length = k + (r - 1)*step
    states = sorted(extensions(pattern, m, r))
    index = {word: a for a, word in enumerate(states)}
    out = [Counter() for _ in states]
    for order in extensions(pattern, m, r + 1):
        a = index[tuple(v for v in order if v < length)]
        b = index[tuple(v - step for v in order if v >= step)]
        out[a][b] += 1
    colors = [0] * len(states)
    while True:
        count = 1 + max(colors)
        rows = []
        for i, edges in enumerate(out):
            row = [0] * count
            for j, n in edges.items():
                row[colors[j]] += n
            rows.append(tuple(row))
        types = [(c, row) for c, row in zip(colors, rows)]
        indices = {x: i for i, x in enumerate(sorted(set(types)))}
        refined = [indices[x] for x in types]
        if refined == colors:
            break
        colors = refined
    return [colors.count(i) for i in range(count)], [rows[colors.index(i)] for i in range(count)]


def multiply(matrix, vector):
    return [sum(a*b for a, b in zip(row, vector)) for row in matrix]


def witness(item):
    p, m, r = item["pattern"], item["m"], item["span"]
    scalar = item["N3_N4_N5"]
    assert r == 3
    mults, matrix = quotient(p, m, r)
    size = len(matrix)
    v = [1] * size
    tail = []
    for _ in range(max(size+2, 4)):
        tail.append(sum(a*b for a, b in zip(mults, v)))
        v = multiply(matrix, v)
    assert scalar == tail[:3]
    det = tail[0]*tail[2] - tail[1]**2
    assert det != 0
    a, rem_a = divmod(tail[0]*tail[3] - tail[1]*tail[2], det)
    b, rem_b = divmod(tail[2]**2 - tail[1]*tail[3], det)
    assert not rem_a and not rem_b and b != 0
    one = [1]*size
    q1 = multiply(matrix, one)
    q2 = multiply(matrix, q1)
    residual = [z - a*y - b*x for x, y, z in zip(one, q1, q2)]
    krylov = []
    v = residual
    for _ in range(size):
        krylov.append(sum(x*y for x, y in zip(mults, v)))
        v = multiply(matrix, v)
    assert not any(krylov)
    return dict(pattern=p, m=m, dimension=sum(mults), cell_sizes=mults, matrix=matrix,
                coefficients=[a, b], initial_minor=det, residual=residual, scalar_residuals=krylov)


if __name__ == "__main__":
    with open(sys.argv[1]) as file:
        for line in file:
            row = json.loads(line)
            if "pattern" in row:
                print(json.dumps(witness(row), separators=(",", ":")))
