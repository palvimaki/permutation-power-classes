# Span and effective Wilf equivalence for consecutive permutation packings

27 November 2026

Finite span gives a decision procedure for comparing two packing sequences.
The proof constructs a finite matrix from orders on consecutive windows.
A known Catalan example refutes the proposed growth dichotomy.
The original questions and test criteria remain in the [registration](PROTOCOL.md).

## 1. Packing counts and distances

Fix a permutation $\pi$ of $[k]$ and an overlap $1\le m<k$. Put $d=k-m$.
In a strip of $j$ copies, window $W_i$ consists of physical positions $id,\ldots,id+k-1$, for $0\le i<j$.
Count each host permutation inducing $\pi$ on every prescribed window. Other occurrences are allowed.
Call this count $N(j)$. Assume the prefix and suffix of length $m$ have the same relative order.

Each window imposes a total order on its positions. Their transitive closure gives the packing poset.
Sorting positions by increasing host value identifies its linear extensions with the counted permutations.
The support $I(u)$ consists of the window indices containing physical position $u$. It is an integer interval.
Define the distance of two positions as $\min\{|a-b|:a\in I(u),\ b\in I(v)\}$.
The span is the supremum of these distances over incomparable pairs in all finite strips.
Use zero for an empty supremum. Positions at distance zero belong to one chain.

## 2. Exact span from the stabilized rank maps (A)

Write $p_1<\cdots<p_m$ and $q_1<\cdots<q_m$ for the sorted prefix and suffix ranks.
Let $P$ and $Q$ denote the corresponding sets. The overlap identifies old rank $q_i$ with new rank $p_i$.
Define
$$
D(z)=\max(\{0\}\cup\{p_i:q_i\le z\}),\qquad
U(z)=\min(\{k+1\}\cup\{p_i:q_i\ge z\}).
$$
For $t\ge1$, let $G(t)$ mean that some $x\in[k]\setminus Q$ and $y\in[k]\setminus P$ satisfy
$$ D^t(x)<y<U^t(x). $$

**Theorem A.** Span is infinite exactly when $G(m+1)$ holds.
Otherwise its exact value is $\max(\{0\}\cup\{t:1\le t\le m,\ G(t)\})$.
In particular, finite span is at most $m$.

**Proof.** First consider two consecutive blocks of windows.
An incoming window meets the preceding union precisely in its overlap with the preceding window.
Every old physical position in the incoming window lies between its start and the preceding window's end.
This holds even when a position belongs to three or more windows.

A total order of the old block extends across this shared chain.
Merge the two private lists in each gap between shared elements, including the two end gaps.
An extension also works when adding a window on the left.
Thus every linear extension of any consecutive block extends to the whole strip.
In particular, outside windows cannot turn incomparable positions in the block into comparable ones.

For an incomparable pair, let the earlier support end at $a$ and the later support start at $a+t$.
The first position has rank $x\notin Q$ in $W_a$. The second has rank $y\notin P$ in $W_{a+t}$.
In the block between them, the ranks weakly below $x$ in its final window are exactly those at most $D^t(x)$.
The ranks weakly above $x$ are exactly those at least $U^t(x)$.
Indeed, a comparison across one new window passes through the shared chain.
A lower boundary $z$ admits exactly the shared old ranks $q_i\le z$.
The greatest corresponding new rank gives the next lower boundary, with zero for an empty set.
The least shared new rank with $q_i\ge z$ gives the next upper boundary, with $k+1$ for an empty set.
Starting both boundaries at $x$ proves the formulas by induction.

Conversely, realize any eligible $x,y$ in the first and last windows of the strip with exactly $t+1$ windows.
Rank $x$ occupies a position outside the next window. Rank $y$ occupies a position outside the preceding window.
Their supports in this strip are singletons. The inequalities above give incomparability exactly when the gap is strict.
Thus a distance $t$ occurs exactly when $G(t)$ holds, including $t=1$.

Each map is nondecreasing. Its orbit is monotone from the first comparison of successive terms.
After the first step, each orbit lies in an image of size at most $m+1$.
It follows that the values at steps $m+1$ and $m+2$ agree, and all later values agree.
A strict gap at stabilization therefore gives witnesses at every greater distance.
If no such gap exists, every positive witness distance occurs among $1,\ldots,m$. ∎

The power-class test in the base paper asks whether a gap occurs at **any** distance at least two.
The finiteness test above asks whether a gap occurs at the **stabilized** distance.
These conditions can give different answers.

## 3. Finite span gives a finite matrix (B)

**Theorem B.** Suppose the span is at most $r$, where $r\ge1$.
There is a finite nonnegative integer matrix $T$ such that, for $j\ge r$,
$$ N(j)=\mathbf 1^{\mathsf T} T^{j-r}\mathbf 1. $$

**Construction.** Take one state per linear extension of a strip of $r$ windows.
Take one directed edge per linear extension of a strip of $r+1$ windows.
Its endpoints are its orders on the first and last $r$ windows.
Translate each restriction to start at physical position zero. Preserve the order of its labels.
Set $T_{uv}$ equal to the number of edges from $u$ to $v$. Parallel edges count separately.

**Proof.** Restrict a global order to successive blocks of $r+1$ windows.
Successive restrictions agree on their $r$ common windows. They give a walk.
Conversely, a walk specifies these block orders and agrees on each successive intersection.
The newest block meets the entire earlier union exactly in the shared $r$ windows.
This follows from the increasing physical starts and ends of the blocks.
The two orders on this intersection coincide. Merge their private lists within each gap of that common order.
Repeating gives at least one total order realizing the walk. Every prescribed window lies in a block.

For uniqueness, comparable positions already have a fixed order.
Each incomparable pair has support distance at most $r$.
Choose indices realizing that distance. Both indices lie within one block of $r+1$ consecutive windows of the strip.
Thus the walk fixes the orientation of every incomparable pair as well.
It determines the global order, so restriction is bijective.
When $j=r$, an order is exactly one state, corresponding to a walk with zero edges. ∎

For the ordinary generating function, add its finite initial segment to
$$ z^r\mathbf 1^{\mathsf T}(I-zT)^{-1}\mathbf 1. $$
This proves rationality over $\mathbb Q$. The characteristic polynomial gives a recurrence valid from the start of the represented tail.
For span at most one, take $r=1$. There is one state, and the matrix has entry $N(2)$.

## 4. An explicit cutoff for two finite-span pairs (D)

**Theorem D.** Let both pattern lengths be at most $K$, where $K\ge2$. Define
$$ M(K)=\left\lfloor (K+1)^2/4\right\rfloor,\qquad c(K)=K-2+2\bigl(M(K)!\bigr). $$
If two finite-span pairs agree for $1\le j\le c(K)$, their sequences agree for every $j\ge1$.

**Proof.** For a pattern of length $k$ and overlap $m$, choose $r=m$ using Theorem A.
A state has $k+(m-1)(k-m)=m(k+1-m)\le M(K)$ physical positions.
Its matrix has at most $M(K)!$ states.
For two matrices with $e_1,e_2$ states, start the two represented tails at $h=\max(r_1,r_2)$.
Place the two matrices on the diagonal of a larger matrix. Its powers give the difference on the common tail.
Absorb the offsets $h-r_i$ and the subtraction into the two boundary vectors.
Cayley–Hamilton gives a monic recurrence of order $e_1+e_2$ on that tail.
If the first $e_1+e_2$ terms vanish, every later term vanishes.
Thus comparison through $h+e_1+e_2-1$ suffices. Since $h\le K-1$, the displayed uniform bound follows. ∎

In a computation use $r_i=\max(1,\mathrm{span}_i)$ and the actual state counts.
The bound above has order at most $\exp(O(K^2\log K))$. A polynomial bound remains open.
For unrestricted pairs there are finitely many candidates at fixed $K$.
Taking the maximum first disagreement among inequivalent pairs gives an abstract finite cutoff.
That argument supplies no procedure for finding it. Part I asks for a **small** bound depending on length.
Theorem D gives an explicit bound only when both spans are finite.

## 5. A Catalan counterexample to the growth claim (C)

Take $\pi=1324$ and $m=2$. Label consecutive physical pairs $(A_i,B_i)$ for $0\le i\le j$.
Window $i$ imposes
$$ A_i<A_{i+1}<B_i<B_{i+1}\qquad(0\le i<j). $$
All paths remain on one increasing track or cross from the A track to the B track.
For $j\ge2$, $B_0$ cannot reach $A_j$. A path from $A_j$ first crosses to the B track at index at least $j-1$.
It cannot reach $B_0$. These positions occur only in the first and last windows, respectively.
Their distance is $j-1$. The span is infinite.

The least and greatest positions are $A_0$ and $B_j$.
After deleting them, the two chains have length $j$, with $A_{i+1}<B_i$ in each column.
An extension is a word with $j$ letters A and $j$ letters B.
Every prefix contains at least as many A letters as B letters.
Thus $N(j)=\binom{2j}{j}/(j+1)\le4^j$. This disproves C.

The Catalan enumeration is prior work. Part I credits Liese and Remmel.
Its use here is to disprove the proposed inference from infinite span to growth faster than every exponential.

## 6. A replacement growth dichotomy

This question arose after registration. The criterion uses only two windows.

**Theorem E (written proof).** Put $d=k-m$. Use zero-based physical offsets.
Look at each offset $m\le a<d$ and set $x=\pi_{a+1}$.
If at least one such offset has $D(x)<x<U(x)$, then $N(j)\ge j!$ for every $j$.
Otherwise $N(j)\le d^{k+(j-1)d}$ for every $j$. The alternatives are exclusive.

**Proof.** Partition all physical positions into the $d$ residue classes modulo the stride.
Fix a residue $0\le a<d$.

If $a<m$, a window contains both offsets $a$ and $a+d$.
Every consecutive pair in that residue occurs together in some window.
Within a window, admissibility makes the comparison of offsets $b,b+d$ agree with that of $b+d,b+2d$ whenever all three exist.
Indeed the first pair lies in the prefix of length $m$, and its translate lies in the suffix.
Thus all such pairs have the same orientation, including pairs near the two ends of the strip.
This residue is a chain.

If $m\le a<d$, window $i$ contains position $id+a$ and no other window contains it.
Every window contains one position in this residue, always of rank $x$.
When $D(x)<x<U(x)$, monotonicity gives $D^t(x)\le D(x)<x<U(x)\le U^t(x)$ for every $t\ge1$.
Theorem A's endpoint comparison makes the $j$ positions pairwise incomparable.
Every ordering of this antichain extends to a linear extension.
Indeed, adjoining the chosen order creates no directed cycle, since distinct antichain elements have no path between them.
This gives at least $j!$ extensions.

If the strict gap fails, the positions in two successive windows are comparable in a fixed direction.
Translation and transitivity make this residue a chain.
If all residues are chains, encode an extension by the sequence of residues of its positions.
Each residue has a fixed internal order, so the encoding is injective.
There are at most $d^{k+(j-1)d}$ words. A factorial eventually exceeds every fixed exponential, proving exclusivity. ∎

**Mixed growth rates.** For two pattern lengths at most $K$, an exponential-side count is at most $K^{Kj}$.
For $j=2K^{2K}$ the last $j/2$ factors of $j!$ all exceed $j/2$.
Consequently $j!>(j/2)^{j/2}=K^{Kj}$.
Any two pairs on opposite sides differ by this explicit copy count.
This covers some comparisons involving infinite span. Comparisons between two factorial-side sequences remain open in general.
It also leaves open comparisons between two exponential-side pairs when at least one has infinite span.

## Sources and priority

- Blitvić, Kammoun, and Steingrímsson define packing counts and pose the small-cutoff question. Their Proposition 5.37 discusses the Catalan example.
  Their Theorem 4.1 uses a different rational function, with variables depending on the number of copies. [Part I](https://arxiv.org/html/2610.29846v1)
- The same authors obtain moment representations for several families. [Part II](https://arxiv.org/abs/2611.12829)
- Nagy constructs the double-factorial family and gives a Lean bridge between packing permutations and linear extensions. [Paper and ancillary files](https://arxiv.org/abs/2611.06937)
- Borga and Penaguião establish the compatible-walk construction for consecutive permutation patterns.
  The bounded-span argument above proves uniqueness for this restricted walk correspondence. [Lemma 3.8](https://doi.org/10.5802/alco.135)
- The power-class paper supplies the rank transfer and consecutive-block extension arguments. [Corrected release](https://github.com/palvimaki/permutation-power-classes/releases/tag/v1.0.2)
- The independent construction by 1337isnot1337 appeared on 26 November 2026. Its pairs have common length $3L+1$ and first differ at $L+1$.
  The author separately recorded the abstract finite-maximum argument. [Dated proof](https://github.com/1337isnot1337/solved-conjectures/blob/3f84597110cb5fa3dcfa6135bf0ee82120a3d431/results/blitvic-kammoun-steingrimsson-packing-cutoff/PROOF.md) · [Follow-up issue](https://github.com/1337isnot1337/solved-conjectures/issues/883)

## Contributions

Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)
Gemini Neon checked the proofs in the original power-class paper.
The new span results have no recorded Gemini Neon or human expert review.
