# Finite span allows arbitrarily large recurrence orders

**Written proofs.** Fable proposed testing eventual geometric growth. Astra 6.2 constructed the examples and derived the results below.

For every positive integer $p$, there is a pattern with overlap eight and span exactly four.
Its packing counts have minimal eventual linear recurrence order $p+1$ over the rationals.
Its length is $16+2p$. This also rules out a recurrence-order bound depending only on span and overlap.
It leaves open a linear cutoff for testing equivalence as a function of pattern length.

## 1. A small example with irrational growth rate

Take overlap five and pattern $(1,5,9,6,3,2,11,4,8,12,10,7)$.
Let $N(j)$ denote its prescribed packing count for $j$ windows. Then
$$
 N(1)=1,\qquad N(j)=9(1,0)
 \begin{pmatrix}9&4\\22&10\end{pmatrix}^{j-2}
 \binom{1}{2}\quad(j\ge2).
$$
The first counts are $1,9,153,2889,54585$.
For $j\ge4$ they satisfy $N(j)=19N(j-1)-2N(j-2)$.
Their exponential growth rate is $(19+\sqrt{353})/2$.
No tail is geometric. An eventual ratio would be rational and would satisfy $x^2-19x+2=0$.

**Construction.** Window $i$ contains five old markers, private positions $X_i,Y_i$, and five new markers.
The new markers become the old markers in the next window.
Assign the old markers formal heights $i+(0,1.2,2.4,1.6,0.8)$, in physical order.
Add one for the new markers. The following intervals prescribe the private positions:
$$
 i<X_i<i+0.8,\qquad i+2.6<Y_i<i+3.4.
$$
Heights specify the marker order. Each private position may move anywhere within its interval.
Reading the window from lowest to highest gives exactly the stated pattern.

The full doubly infinite strip contains one marker at each multiple of $1/5$.
Consecutive markers occur together in a window.
Indeed their physical boundary indices differ by at most one, including the step across an integer.
Thus all markers form one chain.
Finite strips inherit comparisons from the infinite strip.
Any comparison uses a finite path. A linear extension of a finite block extends across either end.
To extend it, merge two total orders on their shared chain.
Consequently additional windows cannot impose a new comparison on an existing pair.

The finite strip therefore consists of its ordered markers and the two families of private positions within their stated intervals.
These constraints already give each window's full order.
Every pair at support distance at least four has disjoint ordered marker intervals.
The intervals of $Y_i$ and $X_{i+3}$ share an open gap, so the span is three.

**Counting.** A complete cell between integers $i$ and $i+1$ contains five marker gaps.
$X_i$ can occupy gaps one through four.
The remaining part of $Y_{i-3}$ can occupy gaps one or two.
The first part of $Y_{i-2}$ can occupy gaps four or five.
Record whether the earlier private position enters from the previous cell.
Record whether the later private position moves on to the next cell.
These two flags index the displayed matrix, in order zero, one.
When neither position occupies this cell, $X_i$ has four choices.
Each shared gap gives an extra choice for the relative order of two positions.
This gives nine choices with only the later position and ten with only the earlier position.
With both, the sixteen gap choices gain four earlier collisions and two later collisions.

For $j\ge2$, the initial positions $X_0,X_1$ have one and three gap choices.
The complete cells run from $i=2$ to $j-1$.
The last two positions $Y_{j-2},Y_{j-1}$ have three and one gap choices.
A remaining incoming position has two gap choices after the final complete cell.
This gives both boundary factors, also when there are no complete cells.
The positive matrix has trace 19 and determinant two. Its larger eigenvalue gives the stated growth rate.

## 2. A family of fixed span and overlap

Use eight marker types $t=0,\ldots,7$. Their integer lifts are
$$ L=(0,1,2,3,2,1,1,0). $$
Marker $(i,t)$ has height $i+L_t+t/8$.
Window $i$ consists in physical order of the following lists:

1. Its eight old markers $(i,t)$ in type order.
2. A private chain of $p$ positions $X_i$ in increasing order.
3. A private chain of $p$ positions $Y_i$ in increasing order.
4. Its eight new markers $(i+1,t)$ in type order.

Place the $X_i$ chain between heights $i$ and $i+7/8$.
Place the $Y_i$ chain between heights $i+3+4/8$ and $i+4+3/8$.
The endpoints form consecutive markers *within this window* in each case.
Hence this prescription gives one permutation of length $16+2p$. Adjacent windows agree on their eight shared positions.

The infinite marker chain has one marker at each multiple of $1/8$.
For neighboring phases, the adjacent lifts differ by at most one.
The final and first lifts are both zero, so the wrap also uses consecutive boundary indices.
Thus consecutive markers always occur together in a window.
The finite strip inherits their order by the extension argument in Section 1.
Conversely, the marker chain and the private chain intervals give every window relation.
They generate exactly the packing poset.

All private elements in a window lie between marker heights $i$ and $i+4+3/8$.
The same bounds include every marker of the window.
Pairs at support distance five or more therefore have ordered, disjoint bounding intervals.
The private intervals for $Y_i$ and $X_{i+4}$ intersect in three complete marker gaps.
Their supporting windows are singletons. Placing both in a common gap permits either relative order.
The span is exactly four.

## 3. Exact transfer and boundaries

For $0\le a,b\le p$ define
$$ H_{ab}=\binom{a+2}{2}\binom{a+3+p-b}{p-b},\qquad A=H^2. $$
Write $e_i$ for the unit column at index $i$, starting from zero.
Then for $j\ge3$,
$$
 N_p(j)=C_p\, e_0^{\mathsf T} A^{j-3} H e_p,\qquad
 C_p=\left[\binom{p+3}{3}\binom{p+5}{5}\right]^2 .
$$

**Proof.** In the interior, private chains start every half period.
They alternate between the early and late families. Every private interval has length $7/8$.
Each half period consists of four marker gaps.
The old chain ends after the first three gaps. The new chain can use all four gaps.
Let $a$ count the old elements still awaiting placement.
Let $b$ count the new elements carried to the following half period.

Place the $a$ old elements into the first three gaps in $\binom{a+2}{2}$ ways.
They split the four available gaps for new elements into $a+4$ ordered insertion places.
Distribute the first $p-b$ new elements over those places in weak order.
This gives the second binomial factor in $H_{ab}$.
The remaining $b$ new elements retain their fixed internal order. Multiplication by $H$ thus advances one half period.

The isolated initial chains $X_0,X_1,X_2$ have respectively one, four, and six available marker gaps.
The isolated final chains $Y_{j-3},Y_{j-2},Y_{j-1}$ have six, four, and one.
These counts follow by retaining the marker indices $0\le i\le j$ in the height formula.
A chain of $p$ elements in $g$ gaps has $\binom{p+g-1}{p}$ placements.
The six isolated chains supply $C_p$.

The remaining starts run from $X_3$ through $Y_{j-4}$ when $j\ge4$.
They cover $2(j-3)$ half periods.
The initial state is zero.
After the final complete half period, $a$ residual elements can occupy three final gaps.
Their terminal count is $\binom{a+2}{2}=H_{a,p}$.
This proves the formula. For $j=3$, only the six isolated chains occur and $H_{0,p}=1$.

## 4. Exact recurrence order

We give the linear algebra argument to exclude transient or invisible states in the count.

**Lemma.** Every square minor of $A$ is strictly positive.

**Proof.** The kernel $B_{xy}=\binom{x+y}{y}$ has strictly positive minors for distinct increasing nonnegative row and column indices.
Vandermonde's identity gives
$$ B_{xy}=\sum_{k\ge0}\binom{x}{k}\binom{y}{k}. $$
All minors of the Pascal matrix $\binom{x}{k}$ are nonnegative.
Its entries count lattice paths from $(-x,0)$ to $(0,k)$ using steps $(1,0)$ and $(1,1)$.
The nonintersecting-path determinant formula gives nonnegativity in the indicated index order.
Equivalently, intersecting path families cancel by exchanging tails at their first intersection.
Only the order-preserving matching can have disjoint paths.

For any minor of size $r$, apply Cauchy–Binet to the kernel factorization.
The term with intermediate columns $0,\ldots,r-1$ is strictly positive.
Both determinants in this term are Vandermonde determinants divided by $\prod_{h=0}^{r-1}h!$.
All remaining terms are nonnegative.

The matrix $H$ uses row indices $a+3$ and column indices $p-b$ of this kernel.
It also has positive row factors. Column reversal gives every minor of size $r$ sign $(-1)^{r(r-1)/2}$.
Cauchy–Binet for $H^2$ pairs two such signs in every term.
Thus every minor of $A$ is strictly positive. In particular, both $A$ and $H$ are invertible.

**Lemma.** For an $n$-square matrix $A$ with strictly positive minors, $e_0^{\mathsf T}$ is a cyclic row.
This means the first $n$ rows $e_0^{\mathsf T} A^i$, starting at $i=0$, are independent.
Likewise, $e_{n-1}$ is a cyclic column.

**Proof.** Stack the first $r$ rows into $K_r$.
Inductively, all maximal minors of $K_r$ are nonnegative and at least one is positive.
This holds for $r=1$.
All maximal minors of $K_r A$ are positive by Cauchy–Binet.
Prepending $e_0^{\mathsf T}$ gives $K_{r+1}$.
Its maximal minors are positive when column zero occurs and zero otherwise.
At $r=n$ this proves independence.
Transpose $A$ and reverse both index orders. These operations preserve positivity of all minors.
The row assertion for this matrix gives the claim for the final column of $A$.

**Theorem.** The minimal eventual recurrence order of $N_p(j)$ is $p+1$.

**Proof.** Put $n=p+1$.
The Hankel matrix of $n$ consecutive rows and columns starting at copy $j\ge3$ factors as
$$
 [N_p(j+u+v)]_{0\le u,v<n}
   = C_p\, K_n A^{j-3}H\,[e_p,Ae_p,\ldots,A^{n-1}e_p].
$$
Here $H$ commutes with $A$. Both outside matrices are invertible by the second lemma.
The middle factors are invertible by the first lemma.
Every such Hankel matrix therefore has rank $n$.
A recurrence of order less than $n$ would make its later columns dependent for every sufficiently large $j$.
Cayley–Hamilton supplies a recurrence of order $n$. This proves equality.

## 5. Bounded checks and scope

The literal order-ideal counter independently reproduced the family formula for $1\le p\le4$ and $3\le j\le7$.
The stabilized rank test gave span four for each of these four patterns.
The same literal counter recovered $1,9,153,2889,54585,1031337,19486233$ for the smaller example.

The proofs cover all positive $p$ and every stated copy count.
The counterexample disproves the proposed eventual-geometric route to a linear cutoff.
Whether a linear equivalence cutoff exists remains a separate question. These results have written proofs only.
