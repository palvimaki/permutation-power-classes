# Span of consecutive permutation packings

The span measures how far apart two incomparable positions can occur across the prescribed windows.
For an admissible overlap of size $m$, every finite span is at most $m$.
An executable rank test decides whether the span is infinite.
It also determines which positive distances occur.

## Results and evidence

| Claim | Status | Evidence |
|---|---|---|
| A. An executable test decides infinite span. Every finite span is at most the overlap. | Lean end to end | [Permutation statements](lean/Span.lean) · [Axiom audit](lean/audit.txt) |
| B. Every finite-span pair has a rational ordinary generating function in the copy count. | Written proof | [Transfer matrix and bijection](RESULTS.md#3-finite-span-gives-a-finite-matrix-b) |
| C. Infinite span forces growth faster than every exponential. | False, by written proof | [Catalan counterexample](RESULTS.md#5-a-catalan-counterexample-to-the-growth-claim-c) |
| D. An explicit cutoff decides equivalence for two finite-span pairs. | Written proof | [Uniform bound](RESULTS.md#4-an-explicit-cutoff-for-two-finite-span-pairs-d) |
| A two-window test distinguishes exponential upper bounds from factorial lower bounds. | Written proof after registration | [Growth criterion](RESULTS.md#6-a-replacement-growth-dichotomy) |
| Span census through pattern length nine | Computed | [Independent algorithms](census-method.md) · [Totals](census.csv) |
| All finite-span matrices and sequences through length eight | Computed, with recurrence certificates | [Methods and example](matrix-method.md) · [Data](matrix-data.jsonl) · [Independent counts](matrix-replay.jsonl) |
| Largest first disagreement through length five, including infinite span | Written proof and computation | [Witnesses and equality proofs](delay_small.md) |
| Original power-class characterization | Written proof and Lean lemmas | [Base paper](../../paper.tex) |

The census tested 701,540 admissible pairs. The two algorithms agreed on all 129,466,252 endpoint comparisons.
The resulting classification has 43,576 finite-span pairs and 657,964 infinite-span pairs.
The Lean theorem justifies the result for arbitrarily many copies.

The matrix census covered all 6,692 finite-span pairs through length eight.
Independent counters checked every matrix entry and 33,628 individual packing counts.
These pairs give exactly six sequences. Three copies suffice to distinguish all six.

For unrestricted pairs, the largest first disagreement is three through length five.
The unrestricted table through length ten remains incomplete.
The explicit cutoff in D applies when both spans are finite.
An effective cutoff for all pairs of bounded length remains open.

The physical-position proof of A bypasses the unfinished Lean proof of the original power-class characterization.
Stage 2 contains A. Stage 3 adds B, C, D, the growth criterion, and the matrix census.
The [research note](RESULTS.md) gives the proofs and credits prior results.
No independent expert has reviewed the new proofs.

## Reproduce the formal verification

Install the Lean toolchain pinned in the repository. From the repository root, run

```sh
research/span/lean/verify.sh
```

The script checks seven named results against the recorded axiom audit.
The two relevant statements are `Packing.Span.permutationSpan_iff` and `Packing.Span.permutationDistance_iff`.
They use physical positions, prescribed window orders, and the first and last window containing each position.
The classifier is `Packing.Span.infiniteSpan?`.
Astra 6.2 checked these definitions against the written statement.
The proof uses a finite permutation directly and the existing rank-transfer library.
It needs no theorem counting all permutations in a power class.

The [registration](PROTOCOL.md) records the original predictions.
Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)
Gemini Neon checked the proofs in the original power-class paper.
