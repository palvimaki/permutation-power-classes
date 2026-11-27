# Packing counts beyond finite span

27 November 2026

**How many copies decide whether two patterns have the same counts?**
For infinite-span patterns at any Fuss–Catalan growth rate, the larger overlap plus two copies suffice.
At rate $27/4$, the worst first disagreement for lengths at most $K$ is exactly $\lfloor(K-1)/3\rfloor$ for $K\ge7$.
The witness patterns attain the bound. [Classification PDF](fuss-catalan.pdf) · [Proof text](CLASSES.md)

**Where do the shared positions lie in a random packing?**
A separate three-page proof gives the inverse-beta curve in Lee and Sah's Conjecture 6.1.
All shared ranks concentrate simultaneously. For each fixed tolerance, the error probability decays exponentially with the number of windows.
[Proof PDF](limit-shape.pdf) · [Proof text](LIMIT-SHAPE.md) · [Original conjecture](https://arxiv.org/pdf/1807.04921#page=10)

## Results and verification

| Claim | Status | Evidence |
|---|---|---|
| Exact span test on permutations | Earlier end-to-end Lean theorem | [Earlier formal proof](../span/README.md) |
| Rationality holds exactly for finite span | Written proof | [Proof and comparison algorithm](ASYMPTOTIC.md) · [Separate proof check](ASYMPTOTIC-AUDIT.md) |
| Complete equivalence test at every Fuss–Catalan rate in infinite span | Written proof | [Classification, witnesses and cutoff](CLASSES.md) · [Boundary tests](boundary-check.json) |
| Equivalence is decidable for all families of width at most two | Written proof | [Finite automata, the counter, and the equality algorithm](TWO-COMPONENT.md) |
| Sharp ternary cutoff | Written proof | [Extremal construction](CLASSES.md#sharp-cutoff-at-the-ternary-rate) |
| Exact factorial exponent for every admissible overlap | Written proof | [Elementary proof](FACTORIAL.md) · [Physical checks](growth-check.jsonl) |
| Exact algebraic growth rate for each exponentially bounded pair | Written proof | [Component formula](ASYMPTOTIC.md) · [Grid and hook-length checks](GRID-CHECKS.md) |
| Arbitrarily large recurrence orders at overlap eight and span four | Written proof | [Construction](STRUCTURE.md) · [Separate proof check](finite-structure-audit.md) · [Positive moment representation](MOMENTS.md) |
| Failure of eventual geometric growth at length ten | Exhaustive computation and exact recurrence certificates | [Census method](finite-method.md) · [Physical enumeration](finite-independent.jsonl) · [Certificates](finite-certificates.jsonl) |
| Lee–Sah Conjecture 6.1 | Written proof | [PDF](limit-shape.pdf) · [Density comparison check](LIMIT-WEIGHT-AUDIT.md) · [Statement check and permutation plot](LIMIT-AUDIT.md) |

The new theorems have written proofs. They await external mathematical review and Lean verification.
Astra 6.2 produced this work. I selected the packing problems and released this work on my GitHub repository. Astra chose the Lee–Sah problem during the investigation. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)
Gemini Neon checked the proofs in the original power-class paper.
Fable checked the earlier span result and proposed the eventual geometric test.
The [registration](PROTOCOL.md) predates the new census.
The Fuss–Catalan classification and Lee–Sah proof arose during the investigation.
[Prior work and search limits](PRIOR.md)

## What the finite census found

Both implementations found zero failures among 36,884 finite-span pairs at length nine.
At length ten they found 104 failures among 286,762 finite-span pairs.
For example, $(5,2,8,1,7,4,10,3,9,6)$ with overlap six gives $1,4,20,116,676,\ldots$.
From $j=2$ it satisfies $N(j+2)=6N(j+1)-N(j)$.
The determinant $N(j)N(j+2)-N(j+1)^2$ equals 64 for every $j\ge2$.
A geometric tail would make it zero. [Exact census and certificates](finite-method.md)

## Physical checks for the infinite-span results

Direct permutation-window counts checked the Catalan and ternary tests on all 10,034 admissible pairs through length seven.
The implementation checked two-copy counts for all pairs. It checked up to six copies when the two-copy count matched.
All predicted members passed. Every other pair differed by six copies.
Eight length-seven pairs had rate $27/4$ and a different sequence from the ternary Fuss–Catalan numbers.
Separate path and physical counts checked the general construction and the shortest ternary witnesses.
[Class census](class-check.jsonl) · [Boundary counts](boundary-check.json)

Run from this directory with Python 3.9 or later.

~~~sh
python3 growth_check.py
python3 class_check.py 2 3 4 5 6 7
python3 boundary_check.py
~~~

Pandoc and the Python Typst binding rebuild both PDFs with `python3 render_papers.py`.

The [finite census instructions](finite-method.md) also give the independent C++ and Python checks.

## Next research target

The unrestricted length-dependent cutoff remains open.
For runs with two components, a single counter compares corresponding marks in their extensions.
This yields an effective recurrence, even when either component has many internal orders.
It covers every packing family of width at most two. [Proof and equality algorithm](TWO-COMPONENT.md)

The next target is a run with three components. Its two adjacent boundaries require two counters.
Start with the three-row grid, whose growth exponent is known here.
Then allow nontrivial internal orders in its middle component.
Test whether the resulting two-counter walks always have a polynomial-coefficient recurrence.
A counterexample would identify where the current comparison method stops.
A proof would extend the equality algorithm beyond two components per run.
