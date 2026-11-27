# Finite-span transfer matrices through length eight

Run with Python 3.9 or later from this directory.

```sh
python3 matrix_census.py > matrix-data.jsonl
python3 matrix_replay.py matrix-data.jsonl > matrix-replay.jsonl
```

The first program scans all permutations and every positive proper overlap.
It checks the order of the shared physical positions.
It groups admissible inputs by length and the two sorted lists of shared ranks.
These lists determine the identifications between successive window chains.
Indeed, send each rank in each window of one pattern to the same rank in the other pattern.
Both gluings identify the same successive rank pairs.
The map therefore descends to a position bijection and preserves every window order.

The stabilized endpoint test selects finite span and gives the exact span.
For span $s$, let $r=\max(1,s)$.
The states are the possible orders on $r$ consecutive windows.
Edges are orders on $r+1$ windows.
The source and target are the restrictions to the first and last $r$ windows.
The target uses positions relative to its left boundary.
One-window states give a scalar matrix.
Its entry is the product of the binomial interleaving counts in the common chain's gaps.
For larger states, the program enumerates physical topological sorts and counts parallel edges.

Each JSON line identifies one rank type, its multiplicity, and its lexicographically first representative.
States list zero-based physical positions in increasing value.
An entry `[a,b,w]` gives the multiplicity from state `a` to state `b`.
The other entries are zero.
The `tail` array starts at copy count `start`, which equals $r$.
For `start` greater than one, the earlier terms are outside this recurrence calculation.
The programme's gluing theorem gives the identity $N(r+i)=\mathbf{1}^T T^i\mathbf{1}$ for all $i\geq0$.

For a matrix with $d$ states, the program generates at least $3d$ consecutive tail terms.
Berlekamp–Massey over the rationals uses the first $2d$ terms to recover a shortest recurrence.
The `recurrence` list gives the coefficients of successively older terms.
The program checks this recurrence against every stored term.
Cayley–Hamilton bounds the true order by $d$.
For a fitted order $e\le d$, the residual sequence also has order at most $d$.
The first $2d$ terms provide at least $d$ consecutive zero residuals.
This proves the fitted recurrence throughout the tail, conditional on the transfer theorem.
Any shorter recurrence would also fit the first $2d$ terms.

The second program independently checks admissibility and enumerates every physical pattern with a listed finite rank type.
For each tested copy count it inserts every pairwise inequality from every physical window.
It counts the orders by deleting their last position and caching the remaining subsets.
Each computed count must equal its corresponding matrix term.
For every rank type it checks the state list for accuracy, uniqueness, and completeness.
It also checks each matrix entry, including zero entries, with the independent counter.
This last check fixes the prefix state and the translated suffix state as extra order constraints.
The endpoint census provides an independent check on the numbers of finite pairs by length and span.

## Results

The matrix file covers 454 finite-span rank types and 6,692 physical pattern–overlap pairs.
The independent counter reproduced all 33,628 tested counts and all 484 matrix entries.
The data give six distinct packing sequences through pattern length eight.
Five have the form $N(j)=b^{j-1}$ with $b$ equal to 1, 2, 3, 4, or 6.
The sixth sequence has $N(1)=1$ and $N(j)=4\cdot5^{j-2}$ for $j\ge2$.

For example, take pattern 13527468 and overlap three.
Its four-state matrix, in file order, is

```math
T=\begin{pmatrix}
1&1&1&1\\
1&1&2&2\\
1&1&1&1\\
1&1&2&2
\end{pmatrix}.
```

Its row sums form the vector $(4,6,4,6)^T$.
Multiplying this vector by $T$ multiplies it by five.
Thus $N(2)=4$, $N(3)=20$, and each subsequent count is five times the preceding count.

The following command groups count prefixes through the certified comparison bound.

```sh
python3 matrix_delay.py matrix-data.jsonl > matrix-delay.jsonl
```

For all lengths through five, the finite-span pairs belong to one class.
The largest first disagreement is two through length six and through length seven.
It is three through length eight.
For example, patterns 13256748 at overlap two and 13527468 at overlap three give $1,4,16$ and $1,4,20$.
For an upper bound, all six sequences satisfy an order-one recurrence from copy one or two.
Once two such sequences agree at copies two and three, their common ratio determines every later term.
The unrestricted extremal-delay question also includes infinite-span pairs.
