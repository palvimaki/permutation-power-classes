"""Build finite-span transfer matrices. Python 3.9+. Write JSON lines to stdout."""
import argparse
import itertools
import json
import math
import sys
from collections import Counter
from fractions import Fraction


def rank_types(k):
    """Collect one representative and its multiplicity for each admissible rank type."""
    groups = {}
    for pattern in itertools.permutations(range(1, k + 1)):
        for m in range(1, k):
            p, q = pattern[:m], pattern[-m:]
            if sorted(range(m), key=p.__getitem__) != sorted(range(m), key=q.__getitem__):
                continue
            key = tuple(sorted(p)), tuple(sorted(q))
            if key in groups:
                groups[key][1] += 1
            else:
                groups[key] = [pattern, 1]
    return groups


def finite_span(k, p, q):
    m = len(p)
    last = 0
    for x in range(1, k + 1):
        if x in q:
            continue
        low = high = x
        for t in range(1, m + 2):
            low = max((a for a, b in zip(p, q) if b <= low), default=0)
            high = min((a for a, b in zip(p, q) if b >= high), default=k + 1)
            if any(y not in p for y in range(low + 1, high)):
                if t == m + 1:
                    return None
                last = max(last, t)
    return last


def words(pattern, m, copies):
    """Yield topological sorts as lists of physical positions in increasing value."""
    k = len(pattern)
    stride = k - m
    n = k + (copies - 1) * stride
    rank_order = sorted(range(k), key=pattern.__getitem__)
    requires = [0] * n
    for w in range(copies):
        for a, b in zip(rank_order, rank_order[1:]):
            requires[w * stride + b] |= 1 << (w * stride + a)

    def generate(word, remaining):
        if not remaining:
            yield tuple(word)
            return
        for v, pred in enumerate(requires):
            bit = 1 << v
            if remaining & bit and not (pred & remaining):
                word.append(v)
                yield from generate(word, remaining ^ bit)
                word.pop()

    yield from generate([], (1 << n) - 1)


def model(pattern, p, q, span):
    k, m = len(pattern), len(p)
    gap_p, gap_q = (0,) + p + (k + 1,), (0,) + q + (k + 1,)
    r = max(1, span)
    stride = k - m
    if r == 1:
        base = 1
        for i in range(m + 1):
            a = gap_p[i + 1] - gap_p[i] - 1
            b = gap_q[i + 1] - gap_q[i] - 1
            base *= math.comb(a + b, a)
        states = [tuple(sorted(range(k), key=pattern.__getitem__))]
        return r, states, [[0, 0, base]]

    states = sorted(words(pattern, m, r))
    indices = {w: i for i, w in enumerate(states)}
    local_length = k + (r - 1) * stride
    entries = Counter()
    for order in words(pattern, m, r + 1):
        prefix = tuple(x for x in order if x < local_length)
        suffix = tuple(x - stride for x in order if x >= stride)
        entries[indices[prefix], indices[suffix]] += 1
    return r, states, [[a, b, value] for (a, b), value in sorted(entries.items())]


def terms(states, entries, length):
    row = [1] * len(states)
    sequence = []
    for _ in range(length):
        sequence.append(sum(row))
        nxt = [0] * len(row)
        for a, b, weight in entries:
            nxt[b] += row[a] * weight
        row = nxt
    return sequence


def recurrence(sequence, d):
    """Use twice the state dimension to recover a shortest scalar recurrence over Q."""
    # Berlekamp--Massey. C[0] is one and sum(C[i] * a[n-i]) is zero.
    c, old = [Fraction(1)], [Fraction(1)]
    order, shift, pivot = 0, 1, Fraction(1)
    for n in range(2 * d):
        discrepancy = sum(c[i] * sequence[n - i] for i in range(order + 1))
        if not discrepancy:
            shift += 1
            continue
        saved = c[:]
        if len(c) < len(old) + shift:
            c.extend([Fraction(0)] * (len(old) + shift - len(c)))
        for i, coefficient in enumerate(old):
            c[i + shift] -= discrepancy / pivot * coefficient
        if 2 * order <= n:
            order, old, pivot, shift = n + 1 - order, saved, discrepancy, 1
        else:
            shift += 1
    coeffs = c[1:order + 1]
    for n in range(order, len(sequence)):
        if sequence[n] + sum(a * sequence[n - i] for i, a in enumerate(coeffs, 1)):
            raise ValueError("failed recurrence prediction")
    return [-a for a in coeffs]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--max-k', type=int, default=8, choices=range(2, 9))
    args = parser.parse_args()
    for k in range(2, args.max_k + 1):
        finite_types = 0
        for (p, q), (pattern, count) in sorted(rank_types(k).items()):
            span = finite_span(k, p, q)
            if span is None:
                continue
            finite_types += 1
            r, states, entries = model(pattern, p, q, span)
            d = len(states)
            sequence = terms(states, entries, max(3 * d, 5))
            coeffs = recurrence(sequence, d)
            print(json.dumps(dict(K=k, overlap=len(p), prefix=p, suffix=q, representative=pattern,
                                  multiplicity=count, span=span, start=r, states=states,
                                  entries=entries, tail=sequence, recurrence=list(map(str, coeffs))),
                             separators=(',', ':')))
        print(f'K={k} finite rank types={finite_types}', file=sys.stderr, flush=True)


if __name__ == '__main__':
    main()
