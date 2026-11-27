# Prior work on growth and rank concentration

Search date: 27 November 2026.

## Growth at one shared position

Fix a pattern of length $K$ and prescribe $n$ copies at stride $K-1$.
Let $N(n)$ count the resulting permutations.
Dwyer and Elizalde give matching bounds for the factorial exponent.
In their Lemma 4.2, equation (4) directly yields

$$
 \log N(n)=s n\log n+O(n),
 \qquad s=K-1-|\pi_K-\pi_1|.
$$

Their marked clusters have maximum possible length for the specified number of copies.
Thus every successive overlap has exactly one position.
The result applies even when the pattern also admits other overlaps. [Dwyer and Elizalde, Lemma 4.2](https://arxiv.org/pdf/1801.08262#page=9)

Lee and Sah sharpen this to

$$
 \log N(n)=s n\log n+c(K,a,b)n+O(\log n).
$$

Here $a<b$ are the endpoint ranks after symmetry.
Their Theorem 1.4 gives the constant explicitly.
Their comparison theorem distinguishes normalized endpoint pairs with a common gap greater than one.
Two-copy counts distinguish normalized endpoint pairs with gap one. [Lee and Sah, Theorem 1.4](https://arxiv.org/pdf/1807.04921#page=3) · [Dwyer and Elizalde, Proposition 4.4](https://arxiv.org/pdf/1801.08262#page=12)

## Random ranks in the same posets

Lee and Sah conjecture an inverse-beta limit shape for the shared vertices in uniform random extensions.
Their published growth theorem estimates the total volume of an order polytope.
Conjecture 6.1 asks where this volume concentrates. [Published article](https://doi.org/10.1016/j.aam.2018.10.001) · [Conjecture 6.1](https://arxiv.org/pdf/1807.04921#page=10)

The exact-conjecture search found the original paper and no independent proof.
OpenAlex lists four works citing the journal article.
Their topics include pattern avoidance in forests, the Goulden–Jackson method, and consecutive-pattern containment.
Rastegar cites the endpoint classification and studies containment bounds.
This search cannot establish priority for unindexed results. [Citation index](https://api.openalex.org/works?filter=cites:W2884595388&per_page=100&select=display_name,doi) · [Rastegar](https://arxiv.org/abs/2304.14733)

The accompanying proof uses Lee and Sah's boundary modification and beta substitution.
It compares probabilities of arbitrary events against uniform order statistics.
The comparison loses only a polynomial factor, so exponential concentration survives.
[Written proof](LIMIT-SHAPE.md) · [Massart's empirical distribution bound](https://doi.org/10.1214/aop/1176990746)

A related physics result predicts the same continuous density.
Pandey, Kumar and Puri study particles with logarithmic repulsion between consecutive particles.
For interaction range one, their equation (29) gives density proportional to $w^{1/(1+\beta)}$.
Here $w$ is the single-particle weight, and $\beta$ is the gap exponent.
Substituting $w(x)=x^p(1-x)^q$ and $\beta=d-1$ gives the Lee–Sah beta density.
Their calculation concerns the mean density and approximates moments of neighboring particles.
It supplies neither simultaneous concentration for extension ranks nor a transfer to the original poset.
[Finite-range Coulomb gas models, Section 4](https://arxiv.org/pdf/1905.10524#page=9)

## Larger overlaps

Blitvić, Kammoun and Steingrímsson define the fixed-overlap counts and discuss a cutoff for their equivalence.
Part I gives recurrences and several explicit families.
Part II studies moment sequences for regular packings. [Part I, Section 7](https://arxiv.org/html/2610.29846v1#S7) · [Part II](https://arxiv.org/abs/2611.12829)

Nagy constructs patterns with counts $(2n-1)!!$ for every overlap $m\ge3$ and length $K\ge2m+1$.
This family has factorial exponent one. [Nagy's construction and Lean files](https://arxiv.org/abs/2611.06937)

## Related periodic posets

Banderier and Wallner study tableaux defined by repeated blocks with periodic walls.
Liu, Liu and Xin give exact ratio limits for two remaining tableau families.
For each family, the ratio $a_{n+1}/[n(n+1)a_n]$ tends to $2\pi^2$.
This implies factorial exponent two.
Their counts concern particular tableau posets.
Applying these formulas to a packing would require an isomorphism. [Banderier and Wallner](https://www.mat.univie.ac.at/~slc/wpapers/FPSAC2021/47Banderier.pdf) · [Liu, Liu and Xin, Theorem 1.3](https://arxiv.org/html/2610.35067v1#S1)

The search found no primary source proving an integer factorial exponent for every fixed admissible overlap.
The verified one-position theorem belongs to Dwyer and Elizalde, with the sharper expansion due to Lee and Sah.
