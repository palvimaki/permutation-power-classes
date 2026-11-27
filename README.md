# Power sequences and delayed disagreement in consecutive permutation packings

Read the [paper](paper.pdf) or its [LaTeX source](paper.tex).
The paper answers the first part of Question 8 and proves the observation in item 9. [Part I, Section 7](https://arxiv.org/html/2610.29846v1#S7)

The [research release](research/frontier/README.md) gives a sharp infinite-span cutoff and a proof of Lee and Sah’s limit-shape conjecture.
The [span programme](research/span/README.md) gives the earlier Lean theorem.

## Results

- **Item 9.** A finite rank test characterizes every positive power class for every proper positive overlap.
  The proof identifies each block of the packing poset at equality.
  For base two, each new copy contributes one isolated incomparable pair.
- **A shorter test.** Set $J=\max(3,m+1)$ for overlap $m$.
  Counts $N(2)=k$ and $N(J)=k^{J-1}$ force $N(j)=k^{j-1}$ for every positive $j$.
  The optimal bound for general $m$ remains unknown.
- **Item 8.** Two patterns of equal length and overlap can first differ at any prescribed copy count of at least four.
  The example with length 21 and overlap 18 first differs from the increasing pattern at six copies.
  The paper also gives this delay against each fixed positive power sequence.
  An independent family appeared on 26 November 2026. [Earlier construction by 1337isnot1337](https://github.com/1337isnot1337/solved-conjectures/blob/3f84597110cb5fa3dcfa6135bf0ee82120a3d431/results/blitvic-kammoun-steingrimsson-packing-cutoff/PROOF.md)
  The span programme gives an explicit upper bound for two finite-span pairs.
  An effective general bound for arbitrary pairs remains open.
- **Chains.** The base-one test includes overlaps larger than half the pattern length.
  Theorem 5.23 of Part I treats overlaps up to half the length.

## Reproduce the checks

Install the Lean toolchain specified in `lean/lean-toolchain` and Python 3.8 or later.
The Lean project uses the standard library. Python uses only its standard library.
Run from this directory with Python assertions enabled.

```sh
./verify.sh
```

The script builds the Lean library and audits the axioms of thirteen named results.
It accepts only standard Lean axioms.
Read the [clean build and test log](verification.log) and the [list of audited statements](lean/Audit.lean).
Build the PDF with `tectonic paper.tex`.

## What Lean proves

| Source | Checked statement |
| --- | --- |
| [Gluing](lean/PowerClasses/Gluing.lean) | Two lists with identical shared order admit a merged list preserving both projections. |
| [Swap](lean/PowerClasses/Swap.lean) | Local lists distinguish all extensions exactly when they cover every incomparable pair. The input includes one extension. |
| [RankCutoff](lean/PowerClasses/RankCutoff.lean) | The two rank transfers stabilize within the finite distance test. This gives the analytic bound for $m+2$ copies. |
| [Transfer](lean/PowerClasses/Transfer.lean) | Iterating the lower and upper rank maps gives exactly the reachable ranks in the graph of window ranks. |
| [Windows](lean/PowerClasses/Windows.lean) | An incoming window meets the previous union exactly where it meets its immediate predecessor. |
| [Blocks](lean/PowerClasses/Blocks.lean) | Independent local choices, edge coverage, and unique labels force one label per connected component. Local degree bounds give the base-two matching. |
| [DelayWitness](lean/PowerClasses/DelayWitness.lean) | Two explicit orders match every prescribed window and differ on a specified pair once that pair exists. |
| [Delay](lean/PowerClasses/Delay.lean) | For every $L\ge5$, the finite windows force one relative order exactly through $L-2$ copies. |
| [Permutations](lean/PowerClasses/Permutations.lean) | Exactly one finite permutation realizes the delayed pattern precisely when $1\le j\le L-2$, assuming $j\ge1$. |
| [CutoffExample](lean/PowerClasses/CutoffExample.lean) | The two finite packing sets admit a bijection exactly through $L-2$ copies. No absolute Wilf cutoff exists. |

The paper proves the complete packing counts, the block sizes, and the stronger $m+1$ bound for $m\ge2$.
A full Lean proof must identify the graph of window ranks with the finite poset on physical positions.
It must derive the block hypotheses for packings and count the resulting extensions.
The item 8 counterexample uses finite permutations directly.
Each permutation lists positions in ascending rank order.
The delayed pattern uses three labelled positions per time step.
The increasing pattern uses position numbers in the same windows.
Both use length $3L$ and overlap $3L-3$.
The complete formula for the delayed family after its first disagreement still has a written proof.
Nagy supplies a formal equality between packing counts and extension counts. [Nagy’s Lean bridge](https://arxiv.org/src/2611.06937v1/anc/PatternPacking/Bridge.lean)

## Computational checks

The [Python program](checks.py) builds the original window inequalities and counts extensions by order ideals.
It checks 5,154 counts across all 1,462 admissible pairs of lengths two through six.
It also checks 1,054 counts across all 172 admissible pairs of length seven with overlaps four through six.
It checks the delayed family at eleven lengths and the inflated construction at three bases.

## Production and release

Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)
Gemini Neon checked the proofs in the original power-class paper.

This repository contains the preprint and its verification files.

[Citation details](CITATION.md)
