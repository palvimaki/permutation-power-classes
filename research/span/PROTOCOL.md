# Span and effective Wilf equivalence

27 November 2026

Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)

This record fixes the proposed tests before this project runs new computations.
The original power-class paper supplies the rank maps and the packing convention.
The prescribed occurrences may coexist with other occurrences.
This programme uses GitHub for publication.

## Predictions

Use admissible overlaps with 1 ≤ m < K. Start the window indices at zero.
The support of a position is the interval of windows containing it.
Distance is the minimum absolute difference between indices in the two supports.
Span is the supremum of distances between incomparable positions over all copy counts.
Assign span zero to chains.

- A. Every finite span is at most m + 1. The stabilized rank maps decide finiteness.
- B. Finite span gives a rational ordinary generating function with a transfer matrix on consecutive windows.
- C. Infinite span forces growth faster than every exponential in the copy count.
- D. There is an explicit length-dependent cutoff for comparing two finite-span pairs.

The predictions came from the existing paper. Its proofs and the published examples were available before registration.
Reading those examples already suggested a possible counterexample to C.
Registration precedes new computations. It does not claim prior ignorance of the literature or its implications.

## Tests and decision rules

1. For lengths 2 through 9, compare the endpoint-rank prediction with reachability in literal window posets.
   Check every distance from 1 through m + 2. Use the minimal strip of t + 1 windows for distance t.
   Check admissibility directly. Log any reductions, counts, incomplete runs, and all disagreements.
   A certified finite span greater than m + 1 refutes A. A long finite observation alone cannot certify finite span.
2. For finite-span pairs through length 8, construct the matrix and compare its predictions with independent exact counts.
   Record its state count and the observed recurrence order. Separate fitted recurrences from identities.
   For a proposed tail order d, use at least 2d terms for fitting and d further terms for prediction when feasible.
   Record any resource limit. A Hankel minor of size d + 1 with nonzero determinant refutes that order on the tested tail.
   A failed fit at a smaller order does not refute rationality.
3. Through length 10, group pairs by their sequence prefixes and record the largest witnessed first disagreement.
   Call that value exact only after proving equivalence within the remaining groups or reaching a proved cutoff for every comparison.
4. An infinite-span construction with an exponential upper bound refutes C. A finite list of counts cannot refute C.
5. Check computed claims with a second implementation that shares no logic with the first.
   Publish the exact domains and distinguish classification from extrapolation.

## Publication and attribution

Preserve the base paper separately. Release stages when their specified proofs and checks exist.
Use a coverage table for written proofs, Lean proofs about permutations, Lean lemmas, computations, and conjectures.
Record the axioms of every headline Lean theorem.
Search for prior work before any release.
Credit the original questions, the moment results, Nagy's Lean bridge, and the concurrent lower-bound construction.
If a quantitative bound appears for the unrestricted problem, investigate its scope before pursuing priority claims.
The polynomial cutoff and the unrestricted effective cutoff are stretch targets.
