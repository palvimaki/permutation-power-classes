# A second audit of the Lee–Sah concentration proof

## Conclusion

I checked the written argument in `LIMIT-SHAPE.md` from the integral to the original extension ranks.
The global comparison and the concentration theorem hold for every permitted triple.
This check does not use the other audit or numerical evidence as proof.
The proof has no Lean verification.

## The change of measure

Write $h=f'$, $h_*=1/\max g'$, and $h_i=h(y_i)$.
The source substitution gives $h^d f^p(1-f)^q=\mathrm{constant}$.
The Jacobian contributes one factor of $h_i$ at each vertex.
Each original vertex weight therefore contributes a constant times $h_i^{1-d}$, including its Jacobian.
The $n$ secants contribute their $(d-1)$-st powers.
Division by the uniform-spacing density gives exactly $W^{d-1}$, up to normalization.
[Lee and Sah, equations (3) and (4)](https://arxiv.org/pdf/1807.04921#page=5)

For $p,q>0$, the beta density increases up to its mode and decreases thereafter.
Hence $h$ decreases and then increases.
Each interval has its maximum derivative at an endpoint, including an interval containing the minimum.
Consequently its secant slope has upper bound $\max(h_i,h_{i+1})$.
Choose an index $k$ of minimal sampled derivative.
The sampled values decrease up to $k$ and increase after $k$, allowing equalities.
Thus
$$
 \prod_{i=0}^{n-1}\max(h_i,h_{i+1})
 =\prod_{i<k}h_i\prod_{i>k}h_i.
$$
Division by the full product gives $W\le1/h_k\le1/h_*$.
This proof also covers a tie that straddles the continuous minimum.

- If $p=0<q$, then $h$ increases. The sampled minimum occurs at $k=0$.
- If $q=0<p$, then $h$ decreases. The sampled minimum occurs at $k=n$.
- If $p=q=0$, then $g=f=\mathrm{id}$ and $W=1$.
- If $d=1$, then $W^{d-1}=1$ on the open simplex, including cases with singular endpoint derivatives.

The endpoints $0,1$ have probability zero. Every secant above uses a compact interval inside $(0,1)$.

For the lower bound, take $L=nd+1$ and $\ell=1/(4L)$.
The reference law selects the order statistics numbered $1,1+d,\ldots,1+nd$ from $L$ independent uniforms.
The event that every uniform lies in $[\ell,1-\ell]$ has probability at least $1-2L\ell=1/2$.
The inequalities $f(y)\ge y/\max g'$ and $1-f(y)\ge (1-y)/\max g'$ bound $h$ there by $H=C\ell^{-(p+q)/d}$.
The total variation of $\log h$ there is at most $2\log(H/h_*)$.
The intervals from each $y_i$ to its secant mean-value point have disjoint interiors.
Their total downward variation has the same upper bound.
The remaining term $-\log h(y_n)$ is at least $-\log H$.
This proves $W\ge h_*^2/H^3$ on the event.
The resulting normalization loss is polynomial, uniformly in $n$.

## Ranks and terminology

Conditioning on the relative order preserves the joint distribution of all sorted labels.
The empirical distribution bound therefore applies even though the distinguished labels depend on the full sample.
The simultaneous empirical bound covers every possible label value.
Each old extension lifts by placing the new lower chain first and the new upper chain last.
Each lift has a unique old restriction. The maximal number of lifts is at most $(M+r)!/M!$.
These facts give the required direction of probability comparison. Both transfers preserve exponential concentration.
[Massart's empirical distribution bound](https://doi.org/10.1214/aop/1176990746)

The predecessor count in a sampled **linear extension** equals $R_i-1$.
Predecessors in the original partial order give a different statistic.
Figure 3 in the source divides the predecessor count by $M-1$.
Its difference from $R_i/M$ is $(M-R_i)/(M(M-1))\le1/M$.
Conjecture 6.1 includes both endpoints. Its statement already allows simultaneous control.
The exponential tail strengthens its convergence statement.
[Figure 3](https://arxiv.org/pdf/1807.04921#page=5) · [Conjecture 6.1](https://arxiv.org/pdf/1807.04921#page=10)

## A quantitative consequence

Set $\gamma=d/(d+\max(p,q))$. Then $f$ is globally Hölder continuous with exponent $\gamma$.
Indeed, any interval of length $z$ has a subinterval of length at least $z/2$ in one half of $[0,1]$.
On the left half, $g'(u)\ge c u^{p/d}$. On the right half, $g'(u)\ge c(1-u)^{q/d}$.
Integration gives $g(v)-g(u)\ge c'(v-u)^{1/\gamma}$ throughout the interval.
Inverting proves the assertion.

For any fixed $A>0$, some finite constant $C_A$ gives, for all $n\ge2$,
$$
 \Pr\left(\max_i |R_i/M-f(t_i)|>
 C_A(\log n/n)^{\gamma/2}\right)\le n^{-A}.
$$
To see this, take the empirical deviation $v=D\sqrt{\log n/n}$ in both empirical bounds.
The reference grid differs from the target grid by $O(1/n)$.
The Hölder estimate takes the resulting label error to $O(v^\gamma)$.
The full-sample rank error is $O(v)$, and removing boundary vertices changes each rank fraction by $O(1/n)$.
The weight comparison and boundary deletion cost a fixed power of $n$.
Choosing $D$ sufficiently large absorbs that power and gives the displayed tail.
This estimate gives a uniform rate. Optimal fluctuations remain open here.
