# Exact first disagreement through length five

Consider admissible pairs only. Count copies starting at one.
For two inequivalent pairs, their first disagreement is the least copy count where their enumerations differ.

| K | Largest first disagreement for two pairs of length K | Largest for two pairs of lengths at most K |
|---:|:---:|:---:|
| 2 | No inequivalent pairs | No inequivalent pairs |
| 3 | 2 | 2 |
| 4 | 2 | 2 |
| 5 | 3 | 3 |

The length-five witness uses patterns 13524 and 14325 with overlap two.
Their counts start with (1, 6, 81) and (1, 6, 71), respectively.
These sequences already appear in Part I. The table above extracts the extremal copy count.
[Part I, Table 1 and Section 7](https://arxiv.org/html/2610.29846v1#S2.T1)

## Proof

Let P and Q be the increasing lists of prefix and suffix ranks.
The strip consists of chains with ranks 1 through K.
The construction identifies rank Q[i] in one chain with rank P[i] in the next.
Consecutive identifications account for every repeated physical position because its supporting windows form an interval.
Consequently, each triple (K,P,Q) determines the abstract poset for every copy count.
Reversal of the window order interchanges P and Q.
Reversal of all inequalities complements both lists and sorts them again.
All signatures related by these operations give equal counts for every number of copies.

The [exhaustive output](delay_small.txt) groups these signatures by their two-copy and three-copy counts.
It lists one representative from every signature orbit.
The rows with counts (1,1) have one packing at m+2 copies, as checked by the program.
Theorem 1 of the [base paper](../../paper.tex) now gives one packing at every copy count.

For each other row, a single orbit suffices except for the following equalities within or across lengths.

- **Counts (2,5).** The representatives are 1324 with overlap two and 14253 with overlap three.
  In both cases, write alternating physical positions as A and B, starting with A.
  Number each track from zero.
  For 1324, window i imposes
  $A_i<A_{i+1}<B_i<B_{i+1}$.
  Delete the global minimum $A_0$ and maximum $B_j$.
  The remainder has two chains of length j, with $A_{i+1}<B_i$ for $0\le i<j$.
  For 14253, window i imposes
  $A_i<A_{i+1}<A_{i+2}<B_i<B_{i+1}$.
  Delete the first two elements $A_0,A_1$ and the last element $B_j$.
  The remainder has two chains of length j, with $A_{i+2}<B_i$ for the same indices.
  These relations generate the same rectangle in both cases.
  The deleted elements occupy fixed places in every extension.
- **Counts (3,15).** The representatives are 132 with overlap one and 14523 with overlap two.
  For 132, Part I, Proposition 5.25 gives the product of $2i+1$ over $0\le i<j$.
  For 14523, write the physical window as $A_i,B_i,X_i,A_{i+1},B_{i+1}$.
  Its order is $A_i<A_{i+1}<B_{i+1}<B_i<X_i$.
  The initial chain $A_0,\ldots,A_j,B_j$ precedes all other elements.
  The remaining chain runs from $B_{j-1}$ to $B_0$ with one leaf $X_i$ above each $B_i$.
  Its first element is $B_{j-1}$.
  After removing it, its leaf has $2j-1$ possible insertion places amongst the smaller comb's elements.
  This gives the same product, starting with one extension for one copy.
- **Counts (4,28).** The representatives are 1243 with overlap one, and 12534 and 15324 with overlap two.
  For the first two representatives, Part I, Proposition 5.25 applies with $d=3$ and $\ell=1$.
  For 15324, Proposition 5.28 applies with the same parameters.
  All three counts equal the product of $3i+1$ over $0\le i<j$.
  [Part I, Section 5.2](https://arxiv.org/html/2610.29846v1#S5.SS2)

This accounts for every repeated row through length five.
At lengths at most four, different rows already have different two-copy counts.
At length five, the displayed witness requires three copies.
Distinct rows at lengths three and four provide witnesses requiring two copies.

## Reproduction

Run the following command in this directory.

```sh
python3 delay_small.py
```

The program enumerates every permutation and overlap before reducing by symmetry.
One counter counts order ideals of the literal physical strip.
The other enumerates two-window orders by merging lists of physical positions.
For three windows it multiplies the binomial interleaving counts between consecutive shared positions.
The counters must agree on every admissible pair.
The program also compares the literal two-copy feasibility test with the relative order of the prefix and suffix.

This is a written proof with an exhaustive finite check. No Lean theorem currently certifies this table.
Lengths six through ten remain outside this computation.
