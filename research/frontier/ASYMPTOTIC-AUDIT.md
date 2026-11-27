# Independent check of the growth and rationality arguments

I checked the written proof in [ASYMPTOTIC.md](ASYMPTOTIC.md) against the [span and transfer results](../span/RESULTS.md).
The check found no mathematical error in the stated results.
It used a separate Astra 6.2 session and no numerical experiments.
It covers the version with the Catalan lower bound and the equality classification.

## Order and components

1. Every finite path in the translated graph uses finitely many windows. Those windows lie in one consecutive strip.
2. Adding one adjacent window preserves every total extension on the existing strip. Repeating this works on both ends.
3. Thus an outside path cannot add a comparison between previously incomparable positions.
4. The rank word traverses the condensation graph in one direction and visits each component exactly once.
5. A free residue cannot lie on a cycle. Any closed path would compare it with a translate or with itself.
6. Every chain residue has a self-return of unit displacement from the consecutive comparison theorem.
7. Independent orders on distinct free residues are feasible by concatenating entire components.
8. Listing residues recovers the total order after fixing all free-residue permutations. This gives the factorial exponent.

In a cyclic component, fix a unit walk at one vertex.
A closed walk with opposite displacement at another vertex gives an opposite-sign walk at the first vertex.
To see this, repeat the second walk enough times between a fixed pair of connecting paths.
The unit walk then cancels the displacement exactly.
The resulting nonempty closed walk lifts to a strict cycle, which is impossible.
The same argument applies to any cycle with the wrong sign.
Zero-weight cycles already contradict strictness.
This proves the common direction and positivity of oriented cycle weights.

Deleting other components retains the induced order.
A directed path leaving one component cannot return to it.
Each retained window has $k_C$ positions and stride $d_C$.
The overlap has size $m_C=k_C-d_C$.
A cyclic component requires a repeated letter within its rank-word interval, giving $m_C\ge1$.
Restriction preserves the compatibility of adjacent windows.
Unit walks at the destination convert one connecting path into paths of every sufficiently large oriented displacement.
This proves finite span for each cyclic component.

## Entropy upper and lower bounds

For opposite directions $+,-$, translate the earlier supporting window to the later one.
If this translates an A position, its order increases.
If it translates a B position, its order decreases.
Both cases give the required A-before-B comparison.
For directions $-,+$, translate the later window to the earlier one.
An intervening opposite component supplies the same comparison for nonadjacent runs sharing a direction.

Let a run have $h$ components, $D=\sum d_C$, and $M=\sum m_C$.
Its unrestricted interleaving factor is

$$
 \frac{(Dj+M)!}{\prod_C(d_Cj+m_C)!}.
$$

Stirling's formula gives a positive constant times

$$
  j^{-(h-1)/2}
  \left(\frac{D^D}{\prod_C d_C^{d_C}}\right)^j(1+O(1/j)).
$$

The residual exponent is $M+1/2-\sum_C(m_C+1/2)=-(h-1)/2$.
This checks cancellation of every endpoint term.

For the lower bound, positive cycle weights give finite shortest-path potentials inside each component.
They ensure every generating edge has nondecreasing potential-adjusted time within its component.
The finite list of crossing edges bounds their possible decreases.
For block length greater than this bound, the floor term drops by at most one.
The component shift increases by at least two, so every crossing edge strictly increases the block number.
Nondecreasing block numbers along paths ensure genuine incomparability across components sharing a block.

A common full block contains exactly $b$ positions of every residue.
For fixed $b$ the number of omitted endpoint blocks stays bounded as $j$ increases.
Inside a component, the time intervals of its residues have length $b$.
Their relative offsets are differences of fixed potentials.
Their intersection therefore contains $b-O(1)$ consecutive times, with a loss independent of $b$.
A retained window uses at most a fixed number of consecutive cell times.
Discarding this second fixed loss leaves $b-H$ consecutive windows, uniformly in $b$.
Each total order on that strip extends to the enclosing full block.
All their positions form an induced subposet by the consecutive-window extension property.
Independent block choices concatenate because their numbers never decrease on generating edges.
Taking $j\to\infty$ before $b\to\infty$ gives exactly the claimed entropy lower bound.

## Rationality and the Catalan threshold

Gluing two blocks along a boundary overlap realizes every pair of extensions of the separate blocks.
Their restrictions agree because the overlap is a chain.
Restrictions also distinguish different pairs.
This proves supermultiplicativity with exactly $j+h$ windows.
Applying the component growth limit along multiples of $j$ gives $N_C(j)\le\lambda_C^j$.
No power of $j$ enters this estimate.
The negative multinomial exponent therefore survives in the global upper bound whenever a run has two components.

If $a_j=N(j)/L^j\to0$, the absolute Abel means vanish uniformly in the angle.
A rational function has a pole on its circle of convergence whenever that circle has finite positive radius.
A radial approach to such a pole contradicts the bound on the absolute Abel means.
When a free residue occurs, factorial growth instead gives zero radius.
The transfer theorem handles the remaining finite-span case.

The marked maximum in component A and minimum in component B occur once in every window.
Marks in separate windows are distinct translates along their chain residues.
A path crossing in window $v$ forces $x_i\le x_v$ and $y_v\le y_l$.
Thus it requires $i\le v\le l$, in either orientation of physical time.
For $i\le l$, comparison already follows from $x_i<y_i\le y_l$.
The induced rectangle therefore gives the full Catalan lower bound for every copy count.

Splitting any positive coordinate of an entropy vector into two positive parts strictly increases its factor.
Increasing any coordinate in a vector with two or more parts also strictly increases its factor.
Thus the unique minimum for any nonsingleton run occurs at $(1,1)$ and equals four.
All component rates are at least one.
At equality all singleton runs have rate one and hence exactly one extension for every length.
A stride-one component is already a chain.
In the remaining two-component run, every crossing comes from one window.
Its strongest crossing orders the last A before the first B in that window.
Deleting the initial forced A positions and final forced B positions leaves exactly the rectangle.
This proves the equality classification for all $j$.

The proof uses the existing finite-span transfer theorem and the two-window chain-or-antichain theorem.
This check covers written mathematics only.
