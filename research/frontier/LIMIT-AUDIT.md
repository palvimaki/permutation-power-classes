# Independent audit of the Lee–Sah limit shape

**Date** 2026-11-27. **Status** Written proof. This audit includes no numerical experiments or formal verification.

The argument proves Conjecture 6.1 for every fixed triple. It also gives the limit of the entire permutation plot.

## The statement

Write $u=a-1$, $v=m-b$, and $d=b-a$. Assume $1\le a<b\le m$. Set
$$
 g(x)=\frac{1}{B(1+u/d,1+v/d)}
       \int_0^x t^{u/d}(1-t)^{v/d}\,dt,
 \qquad f=g^{-1}.
$$
The poset $P_n$ joins $n$ chains of length $m$ at their endpoints of ranks $a,b$.
Its distinguished vertices are $X_0,\ldots,X_n$.
Let $H_i$ give the one-based rank of $X_i$ in a uniform linear extension.
The conjecture asks for
$$
 \max_{0\le i\le n}\left|\frac{H_i}{|P_n|}-f((i+1)/(n+2))\right|
 \xrightarrow{\Pr}0.
$$
The maximum includes both endpoints. [Original conjecture, section 6.2](https://arxiv.org/pdf/1807.04921#page=10).

## Comparison with uniform spacings

The auxiliary poset $Q_n$ adds $r=u+v$ vertices. It contains $P_n$ as an induced subposet.
Give each vertex an independent uniform label. Condition the labels to respect the order.
Equation (3) gives this joint density for the distinguished labels, up to normalization:
$$
 \prod_{i=0}^n x_i^u(1-x_i)^v
 \prod_{i=0}^{n-1}(x_{i+1}-x_i)^{d-1},
 \qquad 0<x_0<\cdots<x_n<1.
$$
[Original construction and integral, sections 2–3](https://arxiv.org/pdf/1807.04921#page=4).

Take $y_i=g(x_i)$ and $q=f'$. Then $q(y)^d f(y)^u(1-f(y))^v$ is constant.
Set $\beta=d-1$ and
$$
 R(y)=\frac{\prod_{i=0}^{n-1}
              (f(y_{i+1})-f(y_i))/(y_{i+1}-y_i)}
             {\prod_{i=0}^n q(y_i)} .
$$
The transformed density equals the reference density times $R^\beta/\mathbb{E}R^\beta$.
The reference density is proportional to $\prod_{i=0}^{n-1}(y_{i+1}-y_i)^\beta$.
It gives $y_i=U_{(di+1)}$ for $dn+1$ independent uniform samples.
The endpoint spacing parameters are one. All $n$ interior parameters equal $d$.

Write $q_*=\inf q>0$. The function $q$ decreases and then increases, allowing a constant or monotone function.
The mean value theorem gives a point $z_i\in(y_i,y_{i+1})$ for each secant slope.
Put $h=\log q$. The total increase of $h$ on these disjoint subintervals cannot exceed $h(y_n)-\log q_*$.
Its total decrease cannot exceed $h(y_0)-\log q_*$.
Apply these bounds to $\sum_i[h(z_i)-h(y_i)]-h(y_n)$. Exponentiation gives
$$
 \frac{q_*}{q(y_0)q(y_n)}\le R(y)\le \frac1{q_*}.
$$
All secant products start at zero. The arXiv display in Lemma 4.1 starts the two outer spacing products at one.
Its equation (7) uses all the secants. The argument here proves the required inequality directly.
[Source display and equation (7)](https://arxiv.org/pdf/1807.04921#page=6).

Let $M=dn+1$ and $\delta=1/[4(M+1)]$.
All uniforms lie in $[\delta,1-\delta]$ with probability at least $1-2M\delta>1/2$.
Write $L=\sup g'$. The Lipschitz bound for $g$ gives $f(y)\ge y/L$ and $1-f(y)\ge(1-y)/L$.
Consequently $q(y)\le C y^{-u/d}(1-y)^{-v/d}$. Inside the buffered interval both endpoint derivatives grow at most polynomially in $M$.
The lower comparison now gives $\mathbb E R^\beta\ge c M^{-2\beta(u+v)/d}$.
The upper comparison gives polynomial domination for every measurable event.
This includes $d=1$, when the transformed law equals the reference law.

The uniform empirical distribution bound gives exponential decay for each fixed uniform deviation of the order statistics.
The grid values $(di+1)/M$ differ uniformly from $(i+1)/(n+2)$ by $O(1/n)$.
Polynomial domination preserves exponential decay for each fixed positive error.
Uniform continuity of $f$ transfers this bound to all distinguished labels.

## Transfer to ranks and to the original poset

The sorted labels are independent of their ordering permutation.
Conditioning on a linear extension event preserves the unconditional law of the sorted labels.
The conditional ordering permutation gives a uniform linear extension.
The uniform empirical distribution bound therefore transfers label concentration to normalized rank concentration in $Q_n$.

Every linear extension of $P_n$ extends to $Q_n$.
Indeed, adjoining its comparisons cannot create a cycle because $P_n$ has the induced order.
A fixed extension of $P_n$ admits at most $|Q_n|^r$ lifts, by positioning the $r$ distinguished added vertices.
For any set $E$ of extensions of $P_n$, these inequalities give
$$
 \Pr_{P_n}(E)\le |Q_n|^r\Pr_{Q_n}(\operatorname{restriction}\in E).
$$
Deleting the added vertices changes each normalized rank by at most $2r/|P_n|$.
The original normalized ranks consequently satisfy Conjecture 6.1, with exponentially small probability for each fixed error.

## The full permutation plot

Fix a pattern with first value $a$ and last value $b$. Prescribe its occurrences at intervals of $m-1$ positions.
Allow other occurrences. A uniform packing corresponds to a uniform extension of $P_n$.
Give position $j$ the horizontal coordinate $j/|P_n|$ and its normalized rank as vertical coordinate.
The empirical probability measure of all positions converges weakly in probability to the following deterministic measure.
Its first coordinate $s$ is uniform. Its conditional second coordinate has distribution
$$
 \frac{u\,\mathrm{Unif}[0,f(s)]+d\,\delta_{f(s)}
             +v\,\mathrm{Unif}[f(s),1]}{m-1}.
$$

To verify this formula, sample labels directly from the order polytope of $P_n$.
The preceding rank theorem and independent sorted labels give uniform concentration of every distinguished label around $f(i/n)$.
Condition on these distinguished labels.
The private chains in each window have independent ordered samples from three intervals.
Those intervals are $[0,x_{i-1}]$, $[x_{i-1},x_i]$, and $[x_i,1]$.
Their sample sizes are $u,d-1,v$, respectively. The conditional density factors into interval ordering indicators. Their normalized factors give independence between chains. Each individual chain has the usual joint law of order statistics.
Use the left endpoint in each window and count the last endpoint once at the end.

Take a bounded continuous test function on the square. Move each window's horizontal coordinates to $(i-1)/n$.
Uniform continuity makes the total normalized error vanish.
The pooled order statistics in either outside chain have the same sum as the unordered sample.
The interior chain and the left endpoint approach $f((i-1)/n)$ uniformly.
Conditional expectations thus give a Riemann sum for the displayed measure.
For each outside chain, continuity follows by representing the interval sample as an affine function of a uniform variable.
The conditional variance of the average is $O(1/n)$, since each window has bounded size.
The sorted-label bound transfers this convergence from labels to ranks.
A countable dense set of continuous functions determines weak convergence on the compact square.
Both marginals are uniform since each finite permutation has both marginals uniform on the same grid.
Value complement gives the decreasing case $a>b$ by vertical reflection.

The singular component is exactly the graph measure with mass $d/(m-1)$.
The outside terms have densities on the square, even when an endpoint density is unbounded.
Uniqueness of the Lebesgue decomposition identifies the singular components of equal measures.
Their supports are the full graphs because every open horizontal interval has positive graph mass.
Hence equal ascending limits determine the same continuous curve $f$.
The endpoint powers of $g'$ recover the two ratios $u/d$ and $v/d$.
Conversely, both ratios determine $f$ and all three mixture weights.
For fixed length, the ascending limit therefore determines both ordered endpoint ranks.
The orientation of the singular graph distinguishes ascending from descending limits.

## Macroscopic Robinson–Schensted rows and columns

Write $N=n(m-1)+1$. Let $\sigma$ record the relative order of the window entries with ranks in $[a,b)$.
This word starts with its smallest entry and has length $d$.
Write $\lambda_j(\tau)$ and $\lambda'_j(\tau)$ for row and column lengths of the Robinson–Schensted shape.
Take missing rows and columns as zero. For the uniform packing $\Pi_n$ and each fixed $j\ge1$,
$$
 \frac{\lambda_j(\Pi_n)}{N}\xrightarrow{\Pr}\frac{\lambda_j(\sigma)}{m-1},
 \qquad
 \frac{\lambda'_j(\Pi_n)}{N}\xrightarrow{\Pr}0.
$$
For a descending endpoint pair, first complement the pattern and then exchange rows and columns.

The outside points have the submeasure formed by the two uniform terms in the plot formula.
The conditional expectation and variance proof applies with the central terms omitted.
Consequently, their empirical submeasure, with normalization $N$, converges in probability to an absolutely continuous measure.

The following elementary bound applies to any such limit.
Partition the square into $k^2$ equal cells, assigning each boundary point to a single cell.
A monotone sequence visits at most $2k-1$ cells.
Indeed, each new cell advances at least one of the two monotone cell indices.
For fixed $k$, all cell masses converge in probability, since the limiting measure gives the boundaries zero mass.
A union of at most $2k-1$ cells has area below $2/k$.
Absolute continuity makes its limiting mass uniformly small as $k$ increases.
Thus both monotone subsequence maxima among outside points are $o_{\Pr}(N)$.

Retain the central entries of each window, counting its left endpoint and excluding its right endpoint.
Put back the final right endpoint. The resulting permutation is the direct sum of $n$ copies of $\sigma$ and one singleton.
Indeed, the right endpoint exceeds every retained entry in its window.
It equals the minimum retained entry of the next window.
This deterministic description uses both physical position and relative rank.

For any fixed $k$, let $G_k$ be the maximum size covered by $k$ disjoint increasing subsequences.
It adds across direct sums. Restriction to each block gives the upper bound.
Concatenating the respective optimum subsequences across blocks gives equality.
Allow empty subsequences when a block has fewer than $k$ points.
Deleting outside points from $k$ subsequences loses at most $k$ times their outside increasing maximum.
Hence $G_k(\Pi_n)=nG_k(\sigma)+1+o_{\Pr}(N)$ for $k\ge1$.
Greene's theorem identifies $G_k$ with the sum of the first $k$ rows.
Subtracting successive limits yields the row formula.
A decreasing subsequence contains at most $d$ central points, since it cannot cross central blocks.
Its outside contribution is $o_{\Pr}(N)$. The first column bounds all remaining columns.
Complement interchanges increasing and decreasing subsequences. Greene's theorem gives the transpose rule.

For example, take patterns $2134576$ and $2154376$. Both have endpoint ranks $(2,6)$.
They have the same permuton. Their central words have relative orders $1234$ and $1432$, respectively.
Their longest increasing subsequence fractions approach $2/3$ and $1/3$, respectively.
Thus the packing records local order information that the common permuton loses.

## Scope of the literature check

The original paper appeared in 2019. [Journal version](https://doi.org/10.1016/j.aam.2018.10.001).
OpenAlex and Semantic Scholar each returned the same four citing papers.
I checked their arXiv texts for the conjecture, limit shapes, and references to Lee and Sah.
None stated a solution to this conjecture.

- [Rastegar, Consecutive pattern containment and c-Wilf equivalence](https://arxiv.org/abs/2304.14733)
- [Zhuang, A lifting of the Goulden–Jackson cluster method](https://arxiv.org/abs/2108.10309)
- [Ren, Wilf equivalences for patterns in rooted labeled forests](https://arxiv.org/abs/2007.12690)
- [Garg and Peng, Classical and consecutive pattern avoidance in rooted forests](https://arxiv.org/abs/2005.08889)

GitHub issue searches for the arXiv ID and cluster posets returned zero in the named repository.
Its code search for the exact phrase “cluster poset” also returned zero.
[GitHub issues](https://github.com/1337isnot1337/solved-conjectures/issues?q=%221807.04921%22).
LeftToSolve returned zero items for the arXiv ID, the paper title, “Lee–Sah”, and “cluster posets”.
[LeftToSolve query](https://lefttosolve.com/api/problems?q=1807.04921).
These checks found no previous proof. They cannot establish worldwide priority.


Searches combining permutons, packings, cluster posets, and prescribed consecutive occurrences found no matching plot theorem.
The two packing preprints study structure and enumeration.
Their PDFs returned no occurrences of “permuton”, “limit shape”, or “scaling limit”.
[Part I](https://arxiv.org/abs/2610.29846). [Part II](https://arxiv.org/abs/2611.12829).
Dubach proves shape convergence for independent samples from a permuton.
Prescribed packing positions give a different sampling law. [Dubach, limit shapes of sampled permutations](https://arxiv.org/abs/2307.05768).
