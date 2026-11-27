# Independent proof check for the fixed-span family

Astra 6.2 checked `STRUCTURE.md` on 27 November 2026. This is a separate written check of the construction and proof. It uses no census output. The argument gives minimal eventual order exactly $p+1$ for every positive integer $p$.

## Window orders and short strips

At height $h+t/8$, the marker belongs to boundary $b=h-L_t$. It survives in $j$ windows exactly when $0\le b\le j$. Neighboring heights have boundary indices differing by zero or one, including the wrap. Their markers share a window. Any order of a finite strip extends across another window by merging two orders along their common chain. Applying this at both ends transfers every finite comparison path from the infinite strip to the finite strip.

The two private chains lie between consecutive markers of their own window. The marker order and these chain intervals generate exactly its local constraints. This holds at every window. Private chains $Y_i$ and $X_{i+4}$ can share a marker gap, in either order. All positions from windows at distance at least five have disjoint height bounds. Thus the span is four.

Retaining $0\le h-L_t\le j$ gives the following boundary counts for every $j\ge3$.

| Chain | Phases of the surviving boundary markers, in order | Gaps |
|---|---|---:|
| $X_0$ | $0,7$ | 1 |
| $X_1$ | $0,1,5,6,7$ | 4 |
| $X_2$ | $0,1,2,4,5,6,7$ | 6 |
| $Y_{j-3}$ | $4,5,6,7,1,2,3$ | 6 |
| $Y_{j-2}$ | $4,5,6,2,3$ | 4 |
| $Y_{j-1}$ | $4,3$ | 1 |

The phase order wraps at the next integer in each final chain. These six chain intervals are disjoint from each other and every interior chain. For $j=3$, they exhaust the private chains. For $j=4$, precisely $X_3$ and $Y_0$ remain. The interior then has two half periods and a final three-gap remainder. For larger $j$, the interior contains one $X$ and one $Y$ start per additional window. All their marker gaps survive.

For each half period, place the $a$ old elements in three gaps by weak composition. This leaves $4+a$ insertion sites for the $p-b$ new elements. The chains' internal orders make this decomposition unique in both directions. The terminal residue has three available gaps. Its placement count equals $H_{a,p}$. These facts verify the two boundary factors and the transfer expression, including exponent zero.

## Matrix positivity and absence of cancellations

For the Pascal path determinant, a source farther left reaches the vertical line of a closer source at nonnegative height. To finish below that closer path, it must meet it. The lattice steps change the vertical separation by at most one. Thus inverted matches always intersect. Pascal minors are nonnegative by path cancellation. Intermediate indices $0,\ldots,r-1$ in Cauchy–Binet give positive Vandermonde determinants for any $r$ distinct increasing source indices. This proves strict positivity for all binomial-kernel minors. Reversing the selected column order of $H$ supplies a sign depending only on minor size. In $H^2$ the two signs cancel for every term, so all minors are positive.

For the Krylov rows, prepending $e_0^{\mathsf T}$ preserves a positive maximal minor whenever the selected columns include zero. Every maximal minor vanishes otherwise. Before each such step, multiplication by $A$ makes every maximal minor positive. The final square matrix therefore has positive determinant. Transposition and simultaneous index reversal preserve strict total positivity. This gives invertibility for the Krylov columns starting at $e_p$.

The Hankel determinant factors through both Krylov matrices, $A^{j-3}$, and $H$. Each factor is invertible at every $j\ge3$. The scalar boundary vectors therefore suppress no dimension, even after discarding an arbitrary finite prefix. Cayley–Hamilton gives the matching upper bound. The paper's stated distinction between recurrence order and equivalence cutoff also holds.

## Separate twelve-position example

The phase rule gives one and three initial gaps and three and one final gaps. Each complete cell has four choices for $X_i$. An old $Y$ uses either of its first two gaps. A new $Y$ uses either of its last two gaps. Counting choices, then orders within shared gaps, gives the stated rows $(9,4)$ and $(22,10)$. For two windows the zero-power case gives nine. The trace is 19 and the determinant is two. The positive leading eigenvector contributes to the count. This verifies the growth rate and recurrence onset in the example.
