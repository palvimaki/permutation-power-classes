# Independent checks on the exponential growth formula

**Scope.** These checks concern three families from Blitvić, Kammoun and Steingrímsson.
Astra 6.2 used physical window comparisons and the rectangular hook-length formula.
The theorem under test is the [component growth formula](ASYMPTOTIC.md#the-exponential-growth-constant).

## Seven Catalan examples

Section 7 of Part I lists the following seven pattern–overlap pairs.
For each, a literal order-ideal count reproduced $\binom{2j}{j}/(j+1)$ for $1\le j\le10$.
All 70 comparisons agreed. [Part I, Section 7](https://arxiv.org/html/2610.29846v1#S7)

The table gives the standardized component patterns in rank order.
The signs give the physical time direction of their chains.

| Pattern | Overlap | Components with directions |
|---|---:|---|
| 1324 | 2 | 12 (+), 12 (+) |
| 14253 | 3 | 123 (+), 12 (+) |
| 136245 | 3 | 12 (+), 12 (+), 21 (−) |
| 142536 | 4 | 123 (+), 123 (+) |
| 1376245 | 3 | 12 (+), 12 (+), 321 (−) |
| 369247815 | 5 | 21 (−), 123 (+), 12 (+), 21 (−) |
| 162738495 | 7 | 12345 (+), 1234 (+) |

I built the rank word from physical offsets and grouped residues by mutual reachability.
I checked the direction by reachability between adjacent copies of each residue in a seven-window strip.
All component patterns are monotone. Adjacent component windows share positions.
Hence each restricted packing is a chain for every copy count.
Each pattern has exactly one run of two unit-stride components.
The growth formula gives four in every case. The Catalan formula gives the same rate.

## Fuss–Catalan family

Part I, Proposition 5.37 gives the count for overlap two, prefix $13$, and suffix $2K$.
Set $d=K-2$. For each $4\le K\le10$, I used the increasing order for the remaining letters.
The literal order-ideal counts agreed with
$$
 \frac{1}{(d-1)j+1}\binom{dj}{j}
$$
at every $1\le j\le8$. All 56 comparisons agreed. These include the Catalan example with $K=4$.
[Part I, Proposition 5.37](https://arxiv.org/html/2610.29846v1#S5)

For every $K$, the rank word of this representative is $0,0,1,2,\ldots,d-1,1$.
Thus the two components have strides $1,d-1$ and increase in the same direction.
The second restricted window traverses its $d-1$ residues in order, returning to residue one in the next cell.
Its successive windows concatenate to a chain, and the first component is also a chain.
The component growth formula gives $d^d/(d-1)^{d-1}$.
Stirling's formula gives precisely this rate for the known Fuss–Catalan count.

## An independent rectangle bound for all heights

Take $h\ge2$, set $K=2h$, and take overlap $h$.
The physical pattern lists the odd ranks in increasing order, followed by the even ranks in increasing order.
This gives the unsubdivided shifted grid of Part I.
The component formula predicts one increasing run with $h$ unit-stride chains, hence growth rate $h^h$.
[Part I, Theorem 5.33](https://arxiv.org/html/2610.29846v1#S5)

Write $V_{r,t}$ for the position on row $0\le r<h$ at physical cell $0\le t\le j$.
Within each row the positions increase with $t$.
The remaining generating relations are
$$
 V_{r,t+1}<V_{r+1,t}\qquad(0\le r<h-1,\quad 0\le t<j).
$$
Give $V_{r,t}$ coordinates $(r,t+r)$. Every generating edge goes right or down by one unit.
In the common columns $h-1,\ldots,j$, the induced order is the ordinary rectangular order.
Indeed every horizontal and vertical unit comparison in this rectangle is a generating relation.
The coordinates forbid any additional comparisons between coordinate-incomparable vertices.
Every extension of this rectangle extends to the whole grid.

For the upper bound, instead align rows by $t$.
We have $V_{r,t}<V_{r+1,t}$ for every $t$.
At $t<j$ use the next position on row $r$. At $t=j$ use the previous position on row $r+1$.
The full grid thus contains all order relations of the rectangle with $h$ rows and $j+1$ columns.

Let $T_h(n)$ count rectangular standard Young tableaux of shape $n^h$, with $T_h(0)=1$.
The two comparisons give, for $j\ge\max(1,h-2)$,
$$
 T_h(j-h+2)\ \le\ N_h(j)\ \le\ T_h(j+1).
$$
The rectangular hook-length formula is
$$
 T_h(n)=(hn)!\prod_{a=0}^{h-1}\frac{a!}{(n+a)!}.
$$
For fixed $h$, Stirling's formula gives $T_h(n)=\Theta_h((h^h)^n n^{-(h^2-1)/2})$.
The two rectangle widths differ from $j$ by constants. Thus
$$
 N_h(j)=\Theta_h\!\left((h^h)^j j^{-(h^2-1)/2}\right).
$$
This argument independently recovers the exponential growth rate.
It also determines the polynomial exponent for every unsubdivided shifted grid.
The comparison alone does not give the leading constant.

For $2\le h\le5$, I checked both inequalities at every $\max(1,h-2)\le j\le8$.
I used the literal counter for $N_h(j)$ and the factorial formula for both rectangle counts.
All 29 comparisons agreed. At eight copies the four packing counts were
$1430$, $12310294$, $212012802584$, and $4848332563899256$.

All numerical counts came from the [physical window counter](../span/matrix_replay.py).
These checks cover the displayed families. They do not establish the general component growth theorem.
