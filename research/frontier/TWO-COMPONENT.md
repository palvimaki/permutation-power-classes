# A decision procedure for packing counts with at most two components per run

Esa-Pekka Pälvimäki · 27 November 2026 · Written proof by Astra 6.2.

**Theorem.** Suppose every residue is a chain. Suppose each run of consecutive components with the same direction contains at most two components.
Then each run has an effectively algebraic ordinary generating function in the number of windows.
The full packing sequence has an effectively computable linear recurrence with polynomial coefficients.
Consequently Wilf equivalence is decidable for two inputs satisfying these conditions.
This includes infinite-span inputs and every family of packing posets with width at most two.

Here effective means that an algorithm terminates given the pattern and overlap.
The theorem supplies a computable length-dependent cutoff on this class. Its construction gives no small general numerical bound.
We use the [residue graph and ordinal decomposition](ASYMPTOTIC.md) and its [window-extension property](../span/RESULTS.md).

## One component and its two boundaries

Let $C$ be a strongly connected component. Number windows in its increasing time direction.
For each physical residue $a$ write $(a,t)$ for its position in oriented cell $t$.
A translation to the next window adds one to $t$. Counts are invariant under translating all windows together.
Strip positions of type $a$ in window zero have consecutive cell indices $s_a,\ldots,e_a$.
Write $l_a=e_a-s_a+1$. In windows zero through $j-1$, that interval becomes
$$
 [s_a,e_a+j-1],\qquad n_a=j+l_a-1.
$$
This uses physical window supports and also holds when the overlap exceeds the stride.
Within each type, all positions form a chain increasing in $t$.

There is an integer $w_{ba}$ for each ordered pair of types such that
$$
 (b,u)<(a,v)\quad\Longleftrightarrow\quad v-u\ge w_{ba}.
 \tag{1}
$$
For distinct types, take the minimum oriented weight of a path from $b$ to $a$ in the residue graph.
All its directed cycles have strictly positive weight, so a minimum exists and shortest paths compute it.
Appending a unit-displacement walk at $a$ realizes every larger weight. For equal types take $w_{aa}=1$.
No path can leave the component and return. A weighted path lifts to the infinite strip at every translate.
The extension property identifies this order with the induced order on every finite strip.
Thus (1) applies even when its chosen witness uses windows beyond a finite boundary.

Encode a linear extension by its successive residue letters. The $k$-th letter of type $a$ represents $(a,s_a+k-1)$.
Add a bit to each letter. It designates the final occurrence of its type in this word.
For a prefix, let $p_a$ count its letters of type $a$.
All differences $p_a-p_b$ stay uniformly bounded through every valid word.
Indeed, suppose $p_a>0$ and $b$ still has an unread letter.
Its earliest unread position cannot precede the last consumed $a$ position. Equation (1) gives
$$
 p_a-p_b\le s_b-s_a+w_{ba}.
$$
If $b$ has finished, $p_a-p_b\le n_a-n_b=l_a-l_b$.
If $p_a=0$, the difference is nonpositive. Exchanging the types bounds the opposite difference.
Therefore one computable bound is
$$
 H=\max_{a,b}\{0,\,s_b-s_a+w_{ba},\,l_a-l_b\}.
$$

A deterministic finite automaton now uses the following checks.

1. Fix a reference type $c$. Store the differences $p_a-p_c$, initially zero. Reject if any pairwise difference exceeds $H$ in absolute value.
2. Store the types that have finished. Reject any later letter from a finished type. On a letter's final bit, mark that type finished after processing it.
3. Before reading type $a$, test each unfinished type $b$. Reject if $(s_a+p_a)-(s_b+p_b)\ge w_{ba}$. This test uses the stored differences only.
4. At word end, require every type to have finished. Require $p_a-p_c=l_a-l_c$ for all types. Require $p_c\ge l_c$ using a counter truncated at $l_c$.

The end tests give a common $j=p_c-l_c+1\ge1$ and exactly $j+l_a-1$ letters of each type.
The final bits uniquely identify their last occurrences. Until a type finishes, its next letter exists in the completed word.
The third check tests its earliest unread position. All its later positions follow that one.
Hence the check rejects exactly when a required predecessor remains unread.
Every valid extension satisfies all checks. Conversely, a word passing all checks gives one extension of its specified finite strip.
Thus the accepted words count extensions without multiplicity.

One can also mark a chosen position from each window.
Fix its type $a$ and its cell $t_0$ in window zero. Successive marks represent $(a,t_0+i)$ for $0\le i<j$.
On the subword of type $a$, require precisely $t_0-s_a$ unmarked letters, then a nonempty marked block, then $e_a-t_0$ unmarked letters.
These fixed end counts define a regular language. Other types carry no such mark.
Every valid word now admits precisely one marking. It has exactly $j$ marks in window order.
The window mark and the final-occurrence bit are independent labels on one letter.

## Two components and one counter

Let $A<B$ be the two components of a run. They have the same time direction.
Mark the maximal $A$ position $x_i$ and the minimal $B$ position $y_i$ of window $i$.
The only additional comparisons needed are $x_i<y_i$ for each $i$.
Indeed these imply all comparisons from one component to the other inside that window.
All comparisons arise from windows, and a path cannot leave this run and return.

Use disjoint alphabets for the components. A product automaton checks their two projections with the preceding finite controls.
A lower mark increases a counter, and an upper mark decreases it. All other letters leave it unchanged.
Require the counter to stay nonnegative and end at zero. Start it at zero.
The end condition gives equal numbers of marks and hence equal copy counts in both components.
The prefix condition puts the $i$-th lower mark before the $i$-th upper mark for every $i$.
Therefore accepted words correspond bijectively to extensions of the run, for all $j\ge1$.
The finite controls and the counter act deterministically on the tagged alphabet. The tags are unique for each extension.

Here is an explicit algebraic system. Ignore the counter and let $M_0,M_+,M_-$ count finite-control transitions of each respective type.
A matrix entry counts the different letters producing that transition. Put $G_{uv}(x)$ equal to the length series of balanced paths from $u$ to $v$.
Paths start at counter zero, stay nonnegative, and finish at zero. Count each letter with weight $x$.
The empty path, an initial neutral letter, and the first return after an initial increase give
$$
 G=I+xM_0G+x^2M_+G M_-G. \tag{2}
$$
The first return determines a unique decomposition. Its interior stays above the starting level and obeys the same transition rules.
Every coefficient of $G$ is computable in increasing degree.
This unambiguous finite grammar gives algebraic entries by the Chomsky–Schützenberger enumeration theorem.
One can eliminate the unknowns in (2) on the branch with constant term $I$.
Indeed its Jacobian with respect to the entries of $G$ is the identity at $x=0$.
Adjoining an inverse for its determinant retains this branch and isolates nonsingular solutions over $\mathbb Q(x)$.
Polynomial elimination then supplies univariate annihilating polynomials. [Chomsky and Schützenberger, 1963](https://www.sciencedirect.com/science/article/pii/S0049237X08720238)

Sum the entries from the initial state to accepting states. Write the resulting series as $A(x)$.
Let $D$ be the number of residues in the run, and let $m_R=\sum_a(l_a-1)$.
Every accepted word for $j$ windows has length $Dj+m_R$. Therefore
$$
 A(x)=x^{m_R} F_R(x^D),\qquad F_R(z)=\sum_{j\ge1}N_R(j)z^j.
$$
Taking $x^D=z$ proves that $F_R$ is algebraic over $\mathbb Q(z)$, by transitivity of algebraic extensions.
The substitution and elimination are effective. The coefficient recursion in (2) selects the required branch.
For a singleton run the same finite automaton suffices without the counter. Its length series is rational.
The existing finite-span transfer theorem gives its rational series directly in copy number.

## Combining runs and deciding equality

The packing poset is an ordinal sum of its runs. Its count at $j$ is the product of their counts at $j$.
Its copy-number series is therefore a coefficientwise product of algebraic series.
Such a product is D-finite over $\mathbb Q$, and its coefficients satisfy a polynomial-coefficient linear recurrence.
[Stanley, *Differentiably Finite Power Series*, Theorems 1.5, 2.1, and 2.10](https://math.mit.edu/~rstan/pubs/pubfiles/45.pdf)

These closure steps give an algorithm. Factor an annihilating polynomial and select the factor using exact initial coefficients.
Distinct irreducible factors cannot share a formal series root, so finite truncation eventually distinguishes them.
In the resulting finite algebraic extension, implicit differentiation and linear algebra yield a linear differential equation.
Comparing coefficients yields a recurrence and its starting index.
For products, tensor the finite lists of shifts from the factor recurrences over $\mathbb Q(j)$.
Successive shifts of the product then satisfy a computable linear dependence.
Direct sums and the same method give a recurrence for the difference of two candidate sequences.

Clear denominators. Increase the recurrence's starting index beyond all exceptional integer roots of denominators and its leading coefficient.
Compute both sequences through that index plus the recurrence order. Induction now decides equality at every subsequent copy count.
A nonzero recurrence of order zero gives eventual vanishing directly.
For each fixed length bound, finitely many admissible pairs meet the graph condition.
Taking the maximum comparison bound over these inputs gives a computable cutoff for this class.

Finally, every family of width at most two satisfies the graph condition.
A free residue alone would yield arbitrarily large antichains.
In one run, all oriented cycles have positive weight. Deleting cycles gives a uniform lower bound on weights of paths there.
From each component choose one vertex. Place successive choices far enough apart in *decreasing* oriented time.
The weight bound excludes every forward comparison between them. Component order excludes every backward comparison.
A sufficiently long finite strip contains this entire antichain. Thus a run of three components forces width at least three. ∎

This is a written proof. The present construction does not decide all comparisons involving a run of three or more components.
