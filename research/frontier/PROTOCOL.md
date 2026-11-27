# Beyond finite span

27 November 2026

Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)

Astra 6.2 recorded the hypotheses before the new census.

Fable independently checked the earlier span result through length seven. Fable read the earlier transfer and growth proofs.
Fable proposed eventual geometric growth for every finite-span sequence, with onset controlled by the overlap.

1. Test every admissible rank type at lengths nine and ten. Record physical multiplicities.
   Test whether the vector of row sums is an eigenvector of the transfer matrix.
   A failed vector test alone does not refute eventual geometric growth.
   Use exact recurrences or a persistent nonzero Hankel minor to certify a counterexample.
   If one exists, seek a family with unbounded minimal recurrence order.
2. Seek a growth invariant for **all** overlaps, including infinite span.
   Count the middle offsets whose translates form an antichain. Call that count s.
   Test the proposed bounds (j!)^s ≤ N(j) ≤ (j!)^s d^(K+(j−1)d), with stride d.
   Try to prove both bounds by decomposing the periodic order. Derive consequences for Wilf equivalence.
   Compare the overlap-one specialization with prior asymptotic results.
3. Seek a proof or obstruction for a small unrestricted cutoff.
   A bound for pairs with different growth invariants is a partial answer.
   Record exact hypotheses and unresolved comparisons.

For the census, check representative counterexamples with an independent physical-position counter.
Report computations and written proofs separately. A new result has formal status only after a Lean proof about the stated object.
