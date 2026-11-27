# Positive measures for the fixed-overlap family

**Written proof by Astra 6.2.** Let $N_p(j)$ count the packings in the overlap-eight family of [STRUCTURE.md](STRUCTURE.md).
Fix $p\ge1$, and set $n=p+1$.

**Theorem.** There exist $n$ distinct positive numbers $x_i$ and $n$ positive numbers $w_i$ such that
$$
 N_p(3+t)=\sum_{i=1}^{n} w_i x_i^t \qquad(t\ge0).
$$
The support points are the eigenvalues of the explicit matrix $A$ below.
These masses give the unique positive representing measure on the real line.
Every later tail has the same support, with different masses.

Part II proves related tail results for trees and studies positivity for shifted grids.
The present result concerns this specific family. [Part II, Section 10](https://arxiv.org/html/2611.12829v1#S10)

## Transfer and signs

Use indices $0,\ldots,p$, with unit columns $e_i$. The packing transfer proved in [Section 3](STRUCTURE.md#3-exact-transfer-and-boundaries) gives
$$
 N_p(3+t)=C\,e_0^{\mathsf T}A^tH e_p,\qquad
 H_{ab}=\binom{a+2}{2}\binom{a+3+p-b}{p-b},\qquad A=H^2,
$$
where $C=[\binom{p+3}{3}\binom{p+5}{5}]^2>0$.

Write $s_r=(-1)^{r(r-1)/2}$.
Every minor of $H$ of size $r$ has sign $s_r$, with increasing row and column indices.
Here are the details.
The Pascal kernel $P_{xk}=\binom{x}{k}$ has nonnegative minors.
Its entries count paths from $(-x,0)$ to $(0,k)$ with steps $(1,0),(1,1)$.
In its determinant, intersecting path families cancel in pairs by exchanging their tails at the first intersection.
Fix a common ordering of vertices and paths to resolve ties.
For disjoint families, larger $x$ must pair with larger $k$.
Otherwise the two paths must meet between their common initial abscissa and their endpoints.
This proves the asserted signs.

Vandermonde's identity gives $B_{xy}=\binom{x+y}{y}=\sum_{k}P_{xk}P_{yk}$.
Cauchy–Binet gives nonnegative terms in every $r$-minor of $B$.
The intermediate columns $0,\ldots,r-1$ give two strictly positive Vandermonde determinants, each divided by $\prod_{k=0}^{r-1}k!$.
Thus every minor of $B$ is positive.
The matrix $H$ takes rows $a+3$ and columns $p-b$ of $B$, with positive row factors.
Its reversed column order gives sign $s_r$.
Cauchy–Binet for $H^2$ then proves strict positivity of every minor of $A$.
For every $t\ge0$, the $r$-minors of $A^tH$ are nonzero with sign $s_r$.
For $t=0$ this follows directly from $H$. For $t>0$ it follows by multiplication.

## Ordinary and shifted Hankel forms

Let $K_r$ have rows $e_0^{\mathsf T}A^i$ for $0\le i<r$.
All its maximal minors are nonnegative, and at least one is positive for every $r\le n$.
For $r=1$, this follows from $e_0$.
Given the assertion for $r$, Cauchy–Binet makes every maximal minor of $K_rA$ positive.
Prepending $e_0^{\mathsf T}$ gives $K_{r+1}$.
Every maximal minor containing column zero is positive. Every other maximal minor vanishes.

Let $L_r$ have columns $A^i e_p$ for $0\le i<r$.
Apply the preceding argument to $JA^{\mathsf T}J$, where $J$ reverses coordinates.
Reversal of both index orders preserves strict positivity.
Reversing the columns of the resulting row matrix gives $L_r^{\mathsf T}$.
Hence every nonzero maximal minor of $L_r$ has sign $s_r$, and at least one exists.

Put $m_t=N_p(3+t)$. For every $t\ge0$ and $1\le r\le n$,
$$
  [m_{t+i+j}]_{0\le i,j<r}= C K_r A^tH L_r .
$$
In its Cauchy–Binet expansion, every nonzero determinant term has sign $s_r^2=1$.
At least one such term occurs, since every middle minor has the required strict sign.
Thus the determinant is positive.
In particular, both $n\times n$ Hankel matrices at shifts zero and one are positive definite by Sylvester's criterion.

## Positive spectrum and the measure

Let $q$ be the characteristic polynomial of $A$.
Define a linear functional $T$ on polynomials by $T(x^t)=m_t$.
Cayley–Hamilton and the transfer expression give $T(x^kq)=0$ for every $k\ge0$.
Thus $T$ descends to $V=\mathbb R[x]/(q)$.
The form $\langle f,g\rangle=T(fg)$ is an inner product.
Its Gram matrix in the monomial basis is the positive definite Hankel matrix at shift zero.

Multiplication by $x$ is self-adjoint. Its quadratic form $T(xf^2)$ is positive definite by the shifted Hankel matrix.
Consequently the spectral theorem gives an orthonormal eigenbasis with positive eigenvalues.
The vector $1$ is cyclic, since its iterates give the monomial basis.
Its projections onto the eigenspaces therefore span all of $V$.
This forces $n$ distinct eigenvalues and a nonzero projection onto each eigenline.
They are precisely the roots of $q$, since multiplication by $x$ in $V$ has minimal polynomial $q$.

Write $w_i$ for the squared norm of the projection of $1$ onto eigenline $i$.
The identity $m_t=\langle x^t,1\rangle$ now gives the claimed positive sum.
Any representing measure integrates $q^2$ to zero, so its support lies among the roots of $q$.
The first $n$ moments determine its masses by the invertible Vandermonde matrix.
After shifting by $h$ further terms, its masses become $w_i x_i^h>0$. ∎

**Bounded check.** A separate calculation constructed the permutations directly from the marker heights.
The literal order-ideal counter supplied all counts used in this check.
For $p=1,2,3,4$, the last required copy counts were $6,8,10,12$.
Exact rational elimination gave positive determinants for all 28 ordinary and shifted leading minors of sizes $1,\ldots,p+1$.
The argument above proves the statement for all $p$.

## Why the initial index matters

The smaller length-twelve example in [Section 1](STRUCTURE.md#1-a-small-example-with-irrational-growth-rate) illustrates the distinction.
Its first five counts are $1,9,153,2889,54585$.
They give
$$
\det\begin{pmatrix}1&9&153\\9&153&2889\\153&2889&54585\end{pmatrix}=-41472.
$$
Consequently its sequence starting at one copy has no positive representing measure on the real line.
This is an additional example of the failure already established in Part II.
