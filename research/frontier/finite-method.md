# The test for eventual geometric counts

The census considers every admissible pattern and overlap at the requested lengths.
It groups patterns by their sorted prefix and suffix ranks.
These two lists determine every repeated packing poset up to isomorphism.

For a fixed overlap, write the lists as $p_1<\cdots<p_m$ and $q_1<\cdots<q_m$.
Join rank $p_i$ to rank $q_i$ by a directed edge.
Write $d=K-m$ for the stride.
In any realization, these edges join each physical position to its translate by $d$ inside one window.
The directed paths must therefore have the lengths of the physical residue classes modulo $d$.
This condition suffices. Match each path to one physical residue class of the same length.
Place its ranks in path order on that residue class.
The resulting prefix and suffix have the required orders and rank sets.
Each assignment gives one distinct pattern.
If $h_\ell$ paths have length $\ell$, the signature occurs $\prod_\ell h_\ell!$ times.
A cycle leaves too few vertices in the paths and fails the length test.

The program uses the published span criterion and transfer matrix.
Write $T$ for the matrix and $v=T\mathbf1$ for its row sums.
The eigenvector test compares $Tv$ and $v$ by integer cross multiplication.
A failed eigenvector test alone cannot disprove eventual geometricity.

The separate scalar test determines the shortest recurrence for $\mathbf1^T T^n\mathbf1$.
Cayley–Hamilton bounds its order by the matrix dimension $D$.
The program uses Berlekamp–Massey on the first $2D$ exact terms and checks at least $D$ more.
A candidate recurrence of order at most $D$ then has at least $D$ zero residuals.
The residual sequence itself satisfies the characteristic recurrence. Therefore all subsequent residuals vanish.
Any shorter recurrence would also satisfy the first $2D$ terms.

Let $P(X)$ be the resulting minimal polynomial for the scalar tail.
Deleting its factor $X^h$ removes exactly the transient roots.
Indeed, an eventual ratio $b$ makes $X^a(X-b)$ an annihilator for some $a$.
Polynomial division shows that $P$ divides each annihilator.
Conversely, if $P=X^h(X-b)$, the ratio is $b$ from the indicated term onward.
Every admissible strip has at least one linear extension.
Thus the scalar sequence is eventually geometric exactly when the remaining factor has degree one.
The computation also checks the earlier copy counts to find the first valid onset.

Run from the repository root with Python 3.9 or later.

```sh
python3 research/frontier/finite_census.py 9 10 > research/frontier/finite-census.jsonl
```

## Results

| Length | Admissible pairs | Finite-span pairs | Finite-span signatures | Failed row test | Nongeometric tails |
|---:|---:|---:|---:|---:|---:|
| 9 | 622,416 | 36,884 | 676 | 0 | 0 |
| 10 | 6,232,666 | 286,762 | 1,668 | 104 | 104 |

At length ten, all 104 failures have span three. They occupy four signatures in two recurrence classes. The remaining 286,658 pairs have geometric tails. For 280,214 the ratio starts at copy one. For 6,444 the ratio starts at copy two.

| Overlap | Pattern representative | Pairs | $N(1),\ldots,N(5)$ | Recurrence coefficients |
|---:|---|---:|---|---|
| 6 | $(5,2,8,1,7,4,10,3,9,6)$ | 8 | $1,4,20,116,676$ | $6,-1$ |
| 4 | $(7,5,3,1,9,2,10,8,6,4)$ | 96 | $1,8,116,1832,28964$ | $16,-3$ |

Both recurrences hold from $N(4)$ onward. In the first class, $N(j)N(j+2)-N(j+1)^2=64$ for every $j\ge2$. In the second class, the same minor equals $1200\cdot3^{j-2}$ for every $j\ge2$. Indeed, for a second-order recurrence with coefficients $a,b$, the adjacent minor is multiplied by $-b$ at each step. Neither class can ever have a geometric tail.

## Separate physical recomputation

`finite_verify.cpp` enumerates the actual permutations, tests compatibility directly, and groups them by rank sets. It constructs each finite strip from inequalities on physical positions. Transitive closure tests the span. Deleting maximal elements counts $N(3),N(4),N(5)$ exactly. The program emits every nonzero minor at these three copies, with its physical multiplicity.

`finite_verify.py` reconstructs the transfer for each emitted witness. It enumerates extensions on actual positions, then refines the states by their outgoing counts. States in one final cell have the same outgoing counts to every cell. The smaller quotient matrix therefore preserves the scalar counts. Each certificate prints its matrix $Q$, cell sizes $w$, and coefficients $a,b$. With $D$ cells, put $r=(Q^2-aQ-bI)\mathbf1$. The certificate checks $w^TQ^h r=0$ for $0\le h<D$. Cayley–Hamilton then proves the recurrence at every later copy. Direct evaluation at copy two checks its first step.

Run from `research/frontier` with a C++17 compiler and Python 3.9 or later.

```sh
c++ -std=c++17 -O2 finite_verify.cpp -o finite-verify
./finite-verify 9 10 > finite-independent.jsonl
python3 finite_verify.py finite-independent.jsonl > finite-certificates.jsonl
```

Both independent outputs reproduce the census totals and all four witness signatures. The two overlap-six signatures have physical multiplicity four each. The two overlap-four signatures have multiplicity 48 each. Their transfer certificates compress further to matrices of order two.

For overlap six, the four quotient columns form equal pairs at indices $\{0,2\}$ and $\{1,3\}$. Track the sum within each pair. For overlap four, track sums at $\{0,1,2,3\}$ and $\{4,5\}$. Applying the certificate matrices gives the following exact counts for $j\ge3$:

$$
N_6(j)=(6,4)\begin{pmatrix}3&2\\4&3\end{pmatrix}^{j-3}\binom{2}{2},\qquad
N_4(j)=(24,10)\begin{pmatrix}12&5\\9&4\end{pmatrix}^{j-3}\binom{4}{2}.
$$

Their trace and determinant pairs are $(6,1)$ and $(16,3)$. The initial minors at copy three equal 64 and 3,600. This supplies directly checkable certificates for both exact recurrence orders.
