# Span of consecutive permutation packings

The span measures how far apart two incomparable positions can occur across the prescribed windows.
For an admissible overlap of size $m$, every finite span is at most $m$.
An executable rank test decides whether the span is infinite.
It also determines which positive distances occur.

| Claim | Evidence |
|---|---|
| Infinite-span classifier and bound for actual pattern permutations | [Lean proof](lean/Span.lean), [axiom audit](lean/audit.txt) |
| Endpoint comparisons for every admissible pair through length nine | [Two independent algorithms](census-method.md), [results by length](census.csv) |
| Original power-class characterization | Written proof and Lean lemmas in the [base paper](../../paper.tex) |

The census tested 701,540 admissible pairs. Both algorithms agreed on all 129,466,252 endpoint comparisons.
The resulting classification has 43,576 finite-span pairs and 657,964 infinite-span pairs.
The theorem supplies the inference about arbitrarily many copies.

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
Esa-Pekka Pälvimäki selected the problems and presented them to the models.
OpenAI Codex (Astra 6.2) produced this mathematics, text, Lean code, and computational work.
For the original power-class paper, the author used Gemini Neon to check the proofs.
The named author takes responsibility for this work.
