# A rank formula for the factorial exponent at every overlap

27 November 2026

Astra 6.2 produced this work. I selected the problems and released this work on my GitHub repository. I wrote none of the proofs. [Contact me for corrections.](https://github.com/palvimaki/permutation-power-classes/issues)

A packing prescribes a permutation pattern in each of $j$ windows.
Let $K$ be the window length, $m$ the admissible overlap, and $d=K-m$ the stride.
Use offsets $0,\ldots,K-1$. Let $r_b$ be the rank at offset $b$.
For every $0\le b<m$, mark the closed integer interval with endpoints $r_b,r_{b+d}$.
Let $s$ count the unmarked ranks. Write $N(j)$ for the number of packings.

**Theorem.** For every $j\ge1$,
$$
(j!)^s\le N(j)\le d^{dj+m}(j!)^s.
$$
Consequently $\log N(j)=s j\log j+O_{K,m}(j)$.
Equality of packing counts for all copy numbers implies equality of $s$.

**Proof.** Each position has a residue modulo $d$. A window contains each residue at least once.
Consider two offsets $b,b+d$ within one window.
Admissibility identifies the latter position with offset $b$ of the following window.
Copies of the position at offset $b$ therefore form a chain, oriented by the comparison of the two ranks.
All comparisons between successive offsets in the same residue have the same orientation.
Indeed, shifting both offsets by $d$ preserves their rank comparison whenever they remain inside the window.
Thus every residue which repeats inside one window forms a chain throughout the strip, including both ends.
The first window orders its initial occurrences. Each later window adds one last occurrence to that chain.

All remaining residues occur once in each window, at a private offset $a$ with $m\le a<d$.
Suppose its rank $r_a$ lies in a marked interval. It lies strictly between that interval's endpoints.
If $r_b<r_a<r_{b+d}$, the shared position at offsets $b+d,b$ separates consecutive copies of $a$ in increasing order.
Reversing the inequalities gives decreasing order. Thus each such private residue also forms a chain.

Fix an unmarked rank $x$. Every position shared by two consecutive windows keeps the same side of $x$.
Indeed its ranks in these windows are the endpoints of a marked interval.
A position's supporting windows are consecutive, so its comparison with $x$ stays the same throughout its support.
A position with rank exactly $x$ belongs to one window only.

The $s$ unmarked ranks split the vertices into ordered classes.
Each unmarked rank has its own equality class. The intervening open bands form the other classes.
Every generating window relation stays inside one class or goes forward in this order.
Each equality class contains $j$ private positions. No two share a window.
No path between different positions of an equality class can leave that class and return.
Choose any extension in each band and independently permute each equality class.
Concatenating these lists gives at least $(j!)^s$ extensions.

Conversely, record the residue of every position in an extension.
The resulting word has length $dj+m$ on $d$ letters.
Every chain residue has a fixed internal order.
Specifying the internal orders of the $s$ other residues therefore recovers the extension.
This proves the upper bound. Stirling's formula gives the stated exponent. ∎

**A finite separation bound.** Consider two patterns of lengths at most $K$ with different exponents.
Their counts differ by copy $j=2K^{2K}$.
The upper bound for the smaller exponent contains at most $K^{Kj}$ beyond its factorial factor.
The larger exponent contributes at least one additional $j!$.
The last $j/2$ factors of $j!$ are each greater than $K^{2K}$, so $j!>K^{Kj}$.
This gives a guaranteed comparison even when both spans are infinite.

For overlap one, a single marked interval gives $s=K-1-|r_{K-1}-r_0|$.
Dwyer and Elizalde proved this case. Lee and Sah also determined the coefficient of its linear term.
[Earlier bounds and references](PRIOR.md)

**Sharp range.** If $m\ge d$, each offset is an interval endpoint, so $s=0$.
If $m<d$, at most $K-2m$ private ranks can be unmarked.
Every integer $0\le s\le K-2m$ occurs. To see this, put $t=K-2m-s$.
Take the first pair of aligned prefix and suffix ranks to be $(1,t+2)$.
Give the remaining $m-1$ pairs consecutive ranks $(t+3,t+4),(t+5,t+6),\ldots$.
Use ranks $2,\ldots,t+1$ and the highest $s$ ranks at the private offsets.
The increasing prefix and suffix give an admissible overlap.
Exactly the highest $s$ ranks remain unmarked.
