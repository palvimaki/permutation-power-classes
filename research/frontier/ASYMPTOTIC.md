# Exact exponential growth for packings of bounded width

27 November 2026

Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)

The ordinary packing generating function is rational exactly when the span is finite.
This note also computes the exponential growth constant for every packing on the exponential side of the growth dichotomy.
It includes patterns with infinite span. It uses the [physical-position and transfer theorems](../span/RESULTS.md).
A separate argument gives the power of the factorial for every pattern.

## The graph of residues

Let the window length be $k$, overlap $m$, and stride $d=k-m$. Assume the overlap is admissible.
Write each physical position uniquely as $td+a$, with $0\le a<d$.
Read the offsets of one window in increasing order of their pattern values.
Replace each offset by its residue modulo $d$. This gives a word of length $k$ on $d$ letters.
Form a directed graph from successive letters, including loops.
Retain the difference of their physical cell indices $t$ as the integer weight of each edge.
Use a separate edge for each occurrence in the word.

Repeating these edges at all integer translates gives the order relations for the bi-infinite strip.
A finite directed path lies in a finite set of windows.
The finite packing posets have no directed cycles. Thus no nonempty closed walk in the residue graph has weight zero.
Every extension of a finite strip extends to any larger finite strip containing it.
This follows by gluing successive windows along their shared chains, including on the left.
Consequently, comparison in the bi-infinite strip agrees with comparison inside any finite strip containing both positions.

The strongly connected components of the graph occur as successive intervals in the rank word.
Indeed, a visit to another component followed by a return would put both in the same component.
The word visits every vertex. Its successive edges order the components linearly.

Call a residue free when its physical occurrences form an antichain.
The two-window test identifies precisely these residues.
They have $m\le a<d$ and $D(x)<x<U(x)$ at their window rank $x$.
Every other residue is a chain, with a fixed orientation in physical time. [Two-window test](../span/RESULTS.md#6-a-replacement-growth-dichotomy)

A directed cycle through a free residue would compare a position with one of its translates.
A zero translate would give a strict cycle. Therefore every free residue forms a one-vertex component without a loop.
Conversely, consecutive occurrences of a chain residue have a directed comparison.
Its projection is a closed walk of weight $+1$ or $-1$.
Hence the components without cycles are exactly the free residues.

Write $s$ for the number of free residues and $n=jd+m$ for the strip length.
A free residue occurs exactly $j$ times.
Choose a separate order for each free residue. List the components in their graph order.
Within each cyclic component take any extension of the restricted poset.
The resulting total order respects every window. This realizes the independent choices for the free residues.
Conversely, a word recording the residues of a global extension determines it once these free orders are specified.
Thus
$$
(j!)^s\ \le\ N(j)\ \le\ d^{jd+m}(j!)^s.
$$
In particular, $\log N(j)=s j\log j+O(j)$.
This argument does not require finite span.

## The exponential growth constant

Suppose $s=0$. Each component $C$ has a common time direction $\epsilon_C\in\{+1,-1\}$.
To prove this, suppose two vertices have opposite directions.
At one vertex take its unit-weight directed walk. Travel to the other vertex, repeat its walk, and return.
Enough repetitions make the second walk have weight opposite to the first.
Combining the two closed walks then gives a nonempty closed walk of weight zero.
The same argument shows that every directed cycle in $C$ has strictly positive weight in time $\epsilon_C t$.

Let $d_C$ count the residues of $C$. Delete all other positions from every window.
The remaining physical positions retain their order on the number line.
Each window now has length $k_C$, the number of its retained offsets.
Successive windows shift by $d_C$ retained positions. The overlap is $m_C=k_C-d_C$.
The component contains a repeated letter, since the rank word visits it in one interval and it contains a cycle.
Hence $m_C\ge1$. Standardizing the retained window values gives an admissible pattern.
A path which leaves $C$ cannot return. This restricted pattern therefore gives the induced order on $C$.
The same conclusion holds for finite strips, by the extension property above.

This restricted pattern has finite span.
Orient time as $\epsilon_C t$. For each ordered pair of residues fix a path between them in the component.
Follow that path, then take as many forward unit steps in the destination residue as needed.
This compares the starting residue with every sufficiently late position of the destination residue.
Taking the maximum threshold over all ordered pairs bounds the separation of incomparable positions.
Cell time and window index differ by a bounded amount for each supported position.
The extension property transfers the claim to every finite strip.

The finite-span matrix theorem now computes a nonnegative integer matrix $T_C$.
Set $\lambda_C=\rho(T_C)$, its spectral radius.
Its value equals $\lim_{j\to\infty}N_C(j)^{1/j}$ for the restricted packing counts.
Indeed the sum of all entries of $T_C^h$ gives the counts, up to a fixed shift of $h$.
The spectral-radius formula computes the limit of these entry sums to the power $1/h$.

Group consecutive components of the same direction into maximal runs $R$.
Write $D_R=\sum_{C\in R}d_C$.

**Theorem.** The growth constant exists. It is a computable real algebraic number. Its value is
$$
\lim_{j\to\infty}N(j)^{1/j}
=
\prod_R \left(
\frac{D_R^{D_R}}{\prod_{C\in R}d_C^{d_C}}\prod_{C\in R}\lambda_C
\right).
$$

**Different runs.** If components $A<B$ have opposite directions, every $A$ position lies below every $B$ position.
Choose supporting windows for both positions.
For directions $+,-$, translate the position in the earlier window forward to the later window.
This only increases the $A$ position or decreases the $B$ position.
In the common window the $A$ position lies below the $B$ position by their rank order.
For directions $-,+$, use the earlier window and translate the later position backwards.
Components in different runs with the same direction have an intervening component of opposite direction.
Transitivity again gives full comparison. The poset is thus the ordinal sum of the runs.
Its extension count is the product of their extension counts.

**One run, upper bound.** A global extension chooses an extension of each component and interleaves the resulting lists.
Each list has $d_Cj+m_C$ entries. The multinomial coefficient bounds the interleavings.
Stirling's formula gives the displayed run factor as an upper bound on the limit superior.

**One run, lower bound.** Use oriented cell time $u=\epsilon_R t$.
Inside component $C$, choose a base vertex.
For each residue $a$, let $p_a$ be the minimum oriented weight of a directed path from the base to $a$.
These minima exist because all cycles have positive oriented weight.
A generating edge from $(a,u)$ to $(b,u+e)$ satisfies $p_b\le p_a+e$.
Hence its height $u-p_a$ never decreases.

Number the components of the run by consecutive integers $i(C)$ in rank order.
Choose a positive integer $b$ larger than every absolute height difference on any generating edge of this run.
Assign a position of type $a\in C$ to block
$$
L(a,u)=\left\lfloor (u-p_a)/b\right\rfloor+2i(C).
$$
Edges within a component never decrease the block number.
An edge between distinct components strictly increases it.
Indeed its floor term can decrease by at most one, and its component term increases by at least two.
No path can leave the run and return.
Thus within one block, positions from distinct components have no comparison.

For fixed $b$, the strip contains $j/b-O(1)$ common full blocks as $j$ grows.
The offsets $p_a$ are fixed, and the component shifts use a fixed number of blocks.
In each full block each residue has exactly $b$ positions.
In each component a full block contains all positions of at least $b-H$ consecutive restricted windows.
Here $H$ depends only on the pattern.
Indeed, the allowed cell times for its residues are intervals of length $b$ differing by fixed offsets.
Their intersection contains $b-O(1)$ consecutive cell times.
Each window uses a fixed bounded range of cell times.
Omitting endpoint blocks ensures these windows belong to the finite strip.

Take $b>H$. The component part of a full block admits at least $N_C(b-H)$ extensions.
Every ordering from those consecutive windows extends to the block.
Their induced order agrees with the restricted strip order by the extension property.
Every linear extension of an induced subposet of a finite poset extends to its parent poset.

Within each full block interleave the component orders arbitrarily.
The block has at least
$$
Q_b=\binom{D_Rb}{(d_C b)_{C\in R}}\prod_{C\in R}N_C(b-H)
$$
orders. Every endpoint block has an extension.
Concatenating block orders by increasing block number always respects every comparison.
For fixed $b$ this gives $\liminf_{j\to\infty}N_R(j)^{1/j}\ge Q_b^{1/b}$.
Let $b$ tend to infinity. Stirling's formula and the component limits give the claimed lower bound.

Finite integer matrices and positive integer powers determine every factor.
The characteristic polynomial and real algebraic root isolation compute each spectral radius exactly.
Distinct values therefore certify inequivalence, including for two exponential-growth patterns of infinite span. ∎

## A second characterization of finite span

**Corollary.** Span is finite exactly when $s=0$ and every run consists of one component.

A free residue gives incomparable translates at all distances.
Singleton runs have finite span by the component proof and the ordinal sum between runs.
If a run has at least two components, take two consecutive ones $A<B$.
A path from $A$ to $B$ must remain in their union.
Every cycle in that union has positive oriented weight.
Thus path weights between fixed endpoints are bounded below by the minimum among simple paths.
Place an $A$ position arbitrarily late in oriented time and a $B$ position arbitrarily early.
There is no path from the former to the latter, because its required weight falls below this lower bound.
There is no path in the reverse direction, by component order.
Long enough finite strips contain these positions arbitrarily far apart. ∎

## A converse to the rationality theorem

**Theorem.** The formal ordinary series $F(z)=\sum_{j\ge1}N(j)z^j$ is rational exactly when the span is finite.

Finite span gives a rational function by the transfer theorem.
If $s>0$, the factorial lower bound gives radius of convergence zero.
A rational formal power series always has positive radius of convergence.

Suppose $s=0$ and the span is infinite. Denote the exponential growth constant by $L$.
For each component, $N_C(j+h)\ge N_C(j)N_C(h)$.
Indeed the two consecutive strips of $j,h$ windows intersect in precisely the boundary overlap chain.
Their orders agree on this chain. Merging their private lists in each gap gives an extension realizing both orders.
Different pairs of orders require different extensions.
Taking arbitrarily many blocks of fixed length $j$ now yields $N_C(j)\le\lambda_C^j$.

For a run containing $h$ components, Stirling's formula gives the polynomial factor $O(j^{-(h-1)/2})$ in the multinomial upper bound.
The fixed endpoint constants $m_C$ cancel from the power of $j$.
Write $q=\sum_R (|R|-1)$. The product upper bound gives
$$N(j)=O\!\left(L^j j^{-q/2}\right).$$
The structural corollary gives $q\ge1$, so $N(j)/L^j\to0$.

The series has radius $1/L$ by the root test.
For $0<u<1$ and every angle $\theta$,
$$
(1-u)|F(ue^{i\theta}/L)|
\le (1-u)\sum_{j\ge1}(N(j)/L^j)u^j \longrightarrow 0.
$$
For this limit, bound any finite initial sum and the supremum of the remaining coefficients separately.
A rational function of this radius has a pole somewhere on its boundary circle.
Along the radius through that pole the displayed limit cannot vanish. This contradiction proves the theorem. ∎

**Effective comparison.** Wilf-equivalent pairs have the same span finiteness.
Test both spans from their ranks. Different answers certify inequivalence.
If both spans are finite, the finite matrix test decides equality.
Thus Wilf equivalence is decidable whenever at least one input has finite span.

For fixed length bound $K$, list all mixed finite/infinite pairs and compare their exact counts until each differs.
This algorithm terminates by the theorem.
The largest recorded first disagreement and the finite/finite bound together give a computable length-only cutoff for this class.
The argument supplies no small estimate for the mixed comparisons.

## The smallest infinite-span sequence

**Theorem.** Every infinite-span pair satisfies $N(j)\ge C_j$ for all $j\ge1$, where $C_j$ is the Catalan number.
Among infinite-span pairs, exponential growth constant four occurs exactly for the Catalan counting sequence.

If $s>0$, use $N(j)\ge j!\ge C_j$. The last inequality follows by induction from the Catalan quotient.
These counts have infinite exponential growth constant.

Otherwise choose consecutive components $A<B$ of a common run with at least two components.
Read windows in their common time direction.
In each window $i$, mark the position $x_i$ of maximum $A$ rank and $y_i$ of minimum $B$ rank.
Both sequences are strictly increasing along their chain residues.
We have $x_i<y_l$ whenever $i\le l$.
A path from $x_i$ to $y_l$ must cross from $A$ to $B$ in some window $v$.
It cannot visit another component, since $A,B$ are consecutive.
The source of the crossing edge is at most $x_v$, so $i\le v$.
Its target is at least $y_v$, so $v\le l$. There is no path from $B$ to $A$.
Therefore the $2j$ marks induce two increasing chains with $x_i<y_l$ exactly for $i\le l$.
The ballot-word bijection counts $C_j$ extensions of this rectangle. Each extends to the full strip.

For a run with at least two components, the entropy factor $D^D/\prod d_C^{d_C}$ is at least four.
Its logarithm increases strictly with each coordinate, with derivative $\log(D/d_C)$.
The unique minimum has two coordinates, both one. All component rates are at least one.
A total rate of four therefore requires exactly one run of two stride-one components.
Every remaining run consists of a single component with rate one.
Supermultiplicativity gives $1\le N_C(j)\le \lambda_C^j$.
Thus all remaining runs have exactly one order and contribute no factor.

The two stride-one components are chains.
In the common time direction, let their counts of positions per window be $a,b$.
Index their positions respectively by $A_0,\ldots,A_{j+a-2}$ and $B_0,\ldots,B_{j+b-2}$.
Window $i$ imposes $A_{i+a-1}<B_i$ for $0\le i<j$.
All other cross comparisons follow from those and the two chain orders.
The first $a-1$ positions of the $A$ chain precede all remaining positions.
The last $b-1$ positions of the $B$ chain follow all remaining positions.
Their deletion leaves the Catalan rectangle on $2j$ positions. Hence the sequence is exactly $C_j$.
Conversely this sequence has growth constant four. The known pattern $1324$ realizes it. [Catalan packing example](../span/RESULTS.md#5-a-catalan-counterexample-to-the-growth-claim-c) ∎

These are written proofs. The normalized exponential constant after removing $(j!)^s$ for $s>0$ remains open here.
A general comparison procedure for two infinite-span pairs with identical invariants also remains open here.
