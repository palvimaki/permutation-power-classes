# Wilf equivalence at every Fuss–Catalan growth rate

Esa-Pekka Pälvimäki · 27 November 2026 · Written proof by Astra 6.2.

Let $N(j)$ count permutations with the prescribed pattern on each of $j$ windows.
Allow any pattern length $K$ and admissible overlap $1\le m<K$.
Write $L=\lim N(j)^{1/j}$, allowing infinity, and $H(n)=n^n/(n-1)^{n-1}$ for $n\ge2$.

**Theorem.** Consider all infinite-span pairs with $L=H(r+1)$ for some integer $r\ge1$.
Each counting sequence corresponds to a unique multiset of $r-1$ nonnegative integers.
Every such multiset occurs. For two inputs in this union, agreement through $\max(m_1,m_2)+2$ copies decides equality.
This includes comparisons across different growth rates.

**Exact Fuss–Catalan criterion.** Within this union, the sequence equals
$$
\frac{1}{rj+1}\binom{(r+1)j}{j}
$$
exactly when $N(2)=r+1$ at rate $H(r+1)$.
For $r\ge2$, the rate alone already implies infinite span.
For $r=1$, the infinite-span condition is necessary.
Thus the test describes the entire Fuss–Catalan class for each $r$, among all admissible packings.

Blitvić, Kammoun and Steingrímsson give examples and a family realizing these sequences.
They also ask for a small length-dependent bound on first disagreement.
The bound here applies to an infinite-span subclass. [Part I, Sections 5 and 7](https://arxiv.org/html/2610.29846v1#S7)

## Which components can occur?

Use the [component decomposition and growth formula](ASYMPTOTIC.md).
A free residue gives factorial growth. Otherwise each component has a finite-span transfer matrix.
Its exponential growth rate is an algebraic integer and is at least one.
A component has rate one exactly when every restricted strip is a chain.
This follows from $1\le N_C(j)\le\lambda_C^j$.

Consecutive components with the same time direction form a run.
A run with at least two components contributes the entropy factor $D^D/\prod_i d_i^{d_i}$,
where $d_i$ are its component strides and $D=\sum_i d_i$.
A singleton run contributes entropy factor one.
The total rate is the product of the entropy factors and all component rates.
Infinite span and finite rate require at least one nonsingleton run.
Finite span has an algebraic-integer rate. For $r\ge2$, $H(r+1)$ is rational with reduced denominator $r^r>1$.

Let $S$ be the total stride of all nonsingleton runs.
For fixed run mass $n$, convexity of $x\log x$ bounds its entropy below by $H(n)$.
Indeed, the denominator is largest for the two parts $1,n-1$.
Merging positive parts strictly increases their contribution to the denominator.
For two parts, moving one unit from the smaller to the larger increases that denominator until the smaller equals one.

For $a,b\ge2$, we have $H(a)H(b)\ge4ab\ge4(a+b)>H(a+b)$.
Here $2n\le H(n)<en$, by the usual bounds on $(1+1/(n-1))^{n-1}$.
Thus the product of the entropy factors is at least $H(S)$.
Also $H$ increases strictly, for example by differentiating its logarithm.
At rate $H(r+1)$, it follows that $S\le r+1$.

The product of the component rates is rational because both the target and the entropy factors are rational.
It is an algebraic integer, hence a positive integer.
The reduced denominator $r^r$ of the target therefore divides $\prod d_i^{d_i}$ over the nonsingleton runs.
Convexity as above gives
$$
r^r\ \le\ \prod d_i^{d_i}\ \le\ (S-1)^{S-1}\ \le\ r^r .
$$
Equality forces precisely two strides, $1,r$, in exactly one nonsingleton run.
That run contributes $H(r+1)$ by itself. All component rates equal one.
Conversely, these component conditions give infinite span and the required rate.

This is a finite test. Form the rank-ordered word of physical residues modulo the stride.
Its strongly connected components give the components above. Group them by time direction.
Apply the base-one rank test to each restricted pattern. Equivalently, check uniqueness at two copies and at $\max(3,m_C+1)$ copies.
Here $m_C$ is its restricted overlap. [Power-class theorem](../../paper.pdf)

## The boundary between two chains

All other runs are ordinal summands with unique orders. Delete them.
Reverse the value order if needed to put the stride-$r$ chain above the stride-one chain.
Index windows in their common increasing direction.
Both operations preserve counts.
In window $i$, let $A_i$ denote the lower maximum and $Y_i$ the upper minimum.
All cross relations follow from $A_i<Y_i$ and the two internal chain orders.
The lower chain has a forced initial segment before $A_0$.
Its remaining vertices are exactly $A_0,\ldots,A_{j-1}$ in that order.

Extend the upper chain to windows indexed by all integers.
The gluing theorem preserves the induced order of every finite strip.
Any two vertices lie together in such a strip. The resulting order is total.
Every interval is finite. From either fixed endpoint, the component path bound compares all sufficiently early and late cells.
There are only finitely many residues. Translation is an increasing order automorphism and moves each vertex upwards.
The chain has no endpoints, hence is order-isomorphic to $\mathbb Z$.
Translation adds a fixed positive integer. Its orbits are the $r$ physical residues. Therefore it adds $r$.

Give $Y_0$ coordinate zero. In residue $h\bmod r$, the first upper window starts at $rt_h+h$,
where $t_0=0$ and $t_h\ge0$ for $1\le h<r$.
In that residue it contains $\ell_h$ consecutive translates.
Indeed a physical window intersects each physical residue in consecutive translates.
The union of $j$ windows extends each segment by $j-1$ translates at its upper end.
Now $Y_i$ has coordinate $ri$. Its zero-based rank in the finite upper chain is
$$
b_i=i+\sum_{h=1}^{r-1}\max(0,i-t_h),\qquad 0\le i<j.
$$
Write $B_0,B_1,\ldots$ for the upper chain.
The cross relations reduce to $A_i<B_{b_i}$. Upper vertices after $B_{b_{j-1}}$ form a forced tail.

These thresholds have a bound in terms of the overlap.
Every two consecutive integer coordinates in the infinite upper chain form a cover relation.
A directed path for a cover has one edge, so some window contains both vertices.
For $1\le h<r$, take adjacent coordinates with residues $h-1,h$.
Translate their supporting window to window zero.
Their common quotient under division by $r$ belongs to both corresponding segments there.
Hence $t_h\le t_{h-1}+\ell_{h-1}-1$. Summing gives
$$0\le t_h\le\sum_{u=0}^{r-1}(\ell_u-1)=m_C\le m.$$
The last inequality holds since the restricted overlap retains a subset of the original shared positions.

## Recovery from counts and a linear cutoff

A word records each extension by its lower and upper letters.
After $a$ lower letters, at most $b_a$ upper letters may occur before the next lower letter.
End the word at $(j,b_j)$. This retains the count because all upper letters after the last binding constraint are forced.
In detail, $b_j\ge b_{j-1}+1$. Delete or append forced upper letters after $B_{b_{j-1}}$ to reach the endpoint.
Thus the multiset determines every count.

Conversely, suppose two boundaries first differ at index $i$.
For $j\le i$, the constraints before the last lower letter agree. Hence all those counts agree.
For $j=i+1$, pad both tails to the same upper length, greater than both values of $b_i$.
The larger boundary admits every former word and at least one additional word.
Take $i$ lower letters, then one more upper letter than the smaller boundary allows, and then the final lower letter.
Complete the forced upper tail. This proves strict inequality.
The increments $b_{i+1}-b_i=1+\#\{h\ge1:t_h\le i\}$ recover the multiset, including its cardinality.
With $M=\max(m_1,m_2)$, any two different multisets give different boundaries by $i=M+1$.
Thus counts through $M+2$ decide equivalence.

For two windows the second lower vertex has $b_1+1$ possible positions.
Consequently $N(2)=2+\#\{h\ge1:t_h=0\}$. This equals $r+1$ exactly when all thresholds vanish.
In that case every prefix satisfies $\#B\le r\#A$ and the endpoint is $(j,rj)$.
The ballot count is $\binom{(r+1)j}{j}/(rj+1)$.
For a direct proof, append one upper letter and give lower and upper letters weights $r,-1$.
Each cyclic orbit has $(r+1)j+1$ words since the total weight is $-1$.
Exactly one shift has all proper partial sums nonnegative. Cut after the first global minimum of the partial sums.
Earlier sums exceed this minimum, and later sums are at least this minimum. These conditions also prove uniqueness.
Delete the last upper letter of this shift. This gives the stated count.
Conversely those Fuss–Catalan numbers have rate $H(r+1)$ and second term $r+1$.
At $r=1$ their generating function has a square root singularity and is therefore nonrational.
The [rationality theorem](ASYMPTOTIC.md#a-converse-to-the-rationality-theorem) excludes finite span in that case.

## Realization of every multiset

Fix any ordering of the thresholds. Set $T=\max_h t_h$, including $t_0=0$.
Use $T+2$ physical columns numbered $u=0,\ldots,T+1$.
Each column contains one lower vertex and $r$ upper vertices labelled $h=0,\ldots,r-1$.
Rank the lower vertices first in column order. Rank upper vertices by the distinct integers $r(u+t_h)+h$.
Read these ranks in column order, using the same within-column order each time.
Overlap the windows by all but one column. Translation preserves both internal orders and their separation, so the overlap is admissible.

The lower order is a chain. Window zero contains every upper coordinate from $rT$ through $r(T+1)$.
Its translates generate every consecutive upper comparison. The infinite upper order is therefore a chain.
The induced-order property gives the same restriction on each finite strip.
Each generating cross comparison comes from a window and reduces to its two extreme ranks.
The preceding boundary formula now realizes the prescribed multiset.
The two components have the same direction: the consecutive upper comparisons give a directed cycle through all upper residues modulo translation.
The growth theorem therefore gives rate $H(r+1)$ and infinite span. ∎

Already at $r=2$, consecutive single thresholds $t$ and $t+1$ first disagree at copy $t+2$.
Thus even a fixed infinite-span rate admits arbitrarily late first disagreement as the length increases.
The smallest member $r=1$ gives precisely the Catalan rectangle, with possible forced heads and tails.

The [physical census](class-check.jsonl) tests Catalan and ternary membership through length seven.
A [separate construction check](boundary_check.py) tests the general path formula directly on physical windows.
[Component growth theorem](ASYMPTOTIC.md) · [Original Catalan examples](https://arxiv.org/html/2610.29846v1#S7)

## Generating functions within each class

Write $F_r(z)=1+zF_r(z)^{r+1}$ for the series with constant term one.
Let $T=\max_h t_h$, including $t_0=0$. After $T$ lower steps, every boundary increment equals $r$.
For $0\le b\le b_T$, let $P_{T,b}$ count admissible prefixes with $T$ lower and $b$ upper letters.
These are finite path counts under the given boundary.
Set $N(0)=1$. Splitting immediately before the $(T+1)$st lower step gives
$$
\sum_{j\ge0}N(j)z^j
=\sum_{j=0}^{T}N(j)z^j+
 z^{T+1}\sum_{b=0}^{b_T}P_{T,b}\,F_r(z)^{\,b_{T+1}-b+1}.
$$
Indeed the next lower step leaves height $h=b_{T+1}-b$ below the upper boundary.
Thereafter a lower step increases height by $r$ and an upper step decreases height by one.
Paths from height $h$ to zero factor at their first descents into $h+1$ excursions and $h$ down steps.
Excursions are empty or start with one up step followed by $r+1$ excursions separated by down steps.
This proves the equation for $F_r$ and the displayed formula.
In particular, all these infinite-span generating functions are algebraic.

## Sharp cutoff at the ternary rate

At rate $27/4$ there is a single threshold $t$. The preceding general bound admits an exact refinement.
In the upper chain, window zero has even coordinates $0,2,\ldots,2(\ell_0-1)$.
Its odd coordinates start at $2t+1$.
An odd vertex and its even successor share some window because they form a cover.
Translate this window to window zero. Its largest even coordinate must reach at least $2t+2$.
Thus $t\le\ell_0-2$. The original physical stride $d$ is at least three.
Each physical residue occurs at most $\lceil K/d\rceil$ times in a window. Hence
$$t\le\lceil K/3\rceil-2=\lfloor(K-4)/3\rfloor.$$

For $t\ge1$ take $t+1$ full physical columns $(E_u,A_u,O_u)$ with $0\le u\le t$.
Append the single position $E_{t+1}$. The resulting pattern has length $3t+4$ and stride three.
Rank the lower positions $A_u$ first in increasing order. Rank the upper positions by $E_u=2u$ and $O_u=2(t+u)+1$.
Translation preserves the overlap order.
The three positions $E_t<O_0<E_{t+1}$ generate the entire upper chain under translation.
The lower windows have at least two lower positions each and generate the entire lower chain.
The upper minimum and first odd position give exactly the requested threshold $t$.
For $t=0$, use pattern $31452$ with overlap two, represented by $E_0,A_0,O_0,E_1,A_1$.

Two thresholds $t<t'$ first give different boundaries at index $t+1$. Their counts first differ at copy $t+2$.
For each $K\ge7$, set $T=\lfloor(K-4)/3\rfloor$. The maximum first disagreement occurs at $T+1$.
The witnesses above realize thresholds $T-1$ and $T$ within the length limit.
Therefore the exact worst-case first disagreement among pairs of rate $27/4$ and length at most $K$ is
$$\boxed{\lfloor(K-1)/3\rfloor}\qquad(K\ge7).$$

## Proof status and credit

The author selected the research direction and takes responsibility for this note.
Astra 6.2 developed the mathematics, wrote the text and verification code, and checked the arguments in separate sessions.
These are written proofs. They await external mathematical review and Lean verification.
The growth theorem supplies the component formula used above. [Growth proof and audit](ASYMPTOTIC-AUDIT.md)
