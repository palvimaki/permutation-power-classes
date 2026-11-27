# A limit shape for random linear extensions of cluster posets

Esa-Pekka Pälvimäki, MD, PhD · 27 November 2026

## Result

Fix integers $1\le a<b\le K$. Take $n$ chains of length $K$, each in increasing rank order.
Identify rank $b$ of each chain with rank $a$ of the next chain.
The resulting poset $P_n$ has $M=n(K-1)+1$ vertices.
Write $X_0$ for rank $a$ of the first chain.
Write $X_i$ for rank $b$ of chain $i$, for $1\le i\le n$.
Then $X_0<\cdots<X_n$.

Put $d=b-a$, $p=a-1$, and $q=K-b$.
Define the increasing function $g$ and its inverse $f$ by

$$
 g(x)=\frac{\int_0^x v^{p/d}(1-v)^{q/d}\,dv}
 {\int_0^1 v^{p/d}(1-v)^{q/d}\,dv},
 \qquad f=g^{-1}.
$$

Let $R_i$ denote the one-based rank of $X_i$ in a uniform random linear extension.
Set $t_i=(i+1)/(n+2)$.

**Theorem.** For every $\varepsilon>0$, there are positive constants $c,C$, depending only on $K,a,b,\varepsilon$, such that

$$
 \Pr\!\left(\max_{0\le i\le n}
 \left|\frac{R_i}{M}-f(t_i)\right|>\varepsilon\right)
 \le C e^{-cn}.
 \tag{1}
$$

This implies Conjecture 6.1 of Lee and Sah, with simultaneous control of all spine vertices.
The number of earlier vertices in the sampled total order equals $R_i-1$.
The height convention in Figure 3 changes the normalized value by at most $1/M$.
The maximum error also tends to zero almost surely under any joint coupling across $n$.
This follows by summing (1) for each positive rational tolerance. [Original conjecture](https://arxiv.org/pdf/1807.04921#page=10)

## 1. Continuous labels on the poset

Use the boundary modification of Lee and Sah.
Adjoin a chain of $q$ new vertices above $X_0$.
Adjoin another chain of $p$ new vertices below $X_n$.
Let $Q_n$ denote the resulting poset. Its size is $M+r$, where $r=p+q$.
Both modifications preserve the induced order on $P_n$.
A directed path between old vertices cannot pass through either added chain. [Boundary modification and integral](https://arxiv.org/pdf/1807.04921#page=4)

Give the vertices of $Q_n$ independent uniform labels on $[0,1]$.
Condition on the event that these labels respect every order relation.
Their relative order now gives a uniform random linear extension.
The ordered list of label values is independent of their relative permutation before conditioning.
It therefore retains the ordinary uniform order-statistic law after conditioning.

Write $x_i$ for the label of $X_i$.
Every spine vertex now has a chain of $p$ vertices below it and another of $q$ above it.
Here these chains describe the attached arms, excluding the spine and its intervening vertices.
Each successive pair of spine vertices contains a chain of $d-1$ intervening vertices.
These arms and intervening chains have disjoint interiors.
Given the spine labels, each lower arm contributes $x_i^p/p!$ to the volume.
Each upper arm contributes $(1-x_i)^q/q!$.
Each intervening chain contributes $(x_{i+1}-x_i)^{d-1}/(d-1)!$.
Thus the joint density on $0<x_0<\cdots<x_n<1$ is proportional to

$$
 \prod_{i=0}^n x_i^p(1-x_i)^q
 \prod_{i=0}^{n-1}(x_{i+1}-x_i)^{d-1}.
 \tag{2}
$$

## 2. A polynomial bound for the change of measure

Set $y_i=g(x_i)$ and $h=f'$ on $(0,1)$.
Differentiation shows that $h(y)^d f(y)^p(1-f(y))^q$ is constant.
For $0\le i<n$, define

$$
 s_i=\frac{f(y_{i+1})-f(y_i)}{y_{i+1}-y_i},\quad
 D(y)=\prod_{i=0}^{n-1}(y_{i+1}-y_i)^{d-1},\quad
 W(y)=\frac{\prod_{i=0}^{n-1}s_i}{\prod_{i=0}^n h(y_i)}.
$$

Substitution into (2), including its Jacobian, gives a density proportional to $D(y)W(y)^{d-1}$.
Let $\nu$ denote the probability law with density proportional to $D$ on the ordered simplex.
We prove the following comparison for every measurable event $E$ of the transformed spine labels.

$$
 \Pr_{Q_n}(Y\in E)\le C_0 n^{B}\nu(E),\qquad
 B=3(d-1)(p+q)/d .
 \tag{3}
$$

Write $G=\max_{[0,1]}g'>0$ and $h_*=1/G$.
The function $g'$ first increases and then decreases, allowing an empty increasing or decreasing part.
This follows directly from its beta density.
Consequently, $h=1/(g'\circ f)$ first decreases and then increases, with $h\ge h_*>0$.
The mean value theorem gives $s_i\le\max(h(y_i),h(y_{i+1}))$.
For a sequence that first decreases and then increases, adjacent maxima multiply to its product divided by its minimum.
Indeed, choose an index attaining its minimum and use the endpoint farther from that index in each interval.
Therefore $W\le h_*^{-1}$.

Put $L=nd+1$. Take $L$ independent uniform random variables with order statistics $U_{(1)},\ldots,U_{(L)}$.
Under $\nu$, the coordinates have the joint law

$$
 Y_i=U_{(1+di)},\qquad 0\le i\le n .
$$

Integrating over the $d-1$ skipped values in each gap gives the density proportional to $D$.
The first and last selected values are the minimum and maximum.
Put $\ell=1/(4L)$ and $A=\{\ell\le Y_0,\ Y_n\le1-\ell\}$.
Then $\nu(A)=(1-2\ell)^L\ge1/2$.

Because $g'\le G$, we have $f(y)\ge y/G$ and $1-f(y)\ge(1-y)/G$.
The formula for $h$ now bounds $h$ on $[\ell,1-\ell]$ by $H=C_1\ell^{-(p+q)/d}$.
Choose $C_1$ so that $H\ge h_*$.
The total variation of $\log h$ on this interval is at most $2\log(H/h_*)$.
For each $i<n$, the mean value theorem gives $s_i=h(u_i)$ for some $y_i<u_i<y_{i+1}$.
On $A$, the intervals $[y_i,u_i]$ are disjoint, so

$$
 \begin{aligned}
 \log W
 &= -\log h(y_n)+\sum_{i=0}^{n-1}\bigl(\log h(u_i)-\log h(y_i)\bigr)\\
 &\ge -\log H-2\log(H/h_*).
 \end{aligned}
$$

Thus $W\ge h_*^2/H^3$ on a set of $\nu$-probability at least one half.
In particular $\mathbb E_\nu[W^{d-1}]\ge c_0 n^{-B}$.
Dividing the global upper bound on $W^{d-1}$ by this expectation proves (3).
For $d=1$, the change of measure is exactly one.
The same argument allows $p=0$, $q=0$, or both.

## 3. Concentration of all spine labels and ranks

For $L$ independent uniform random variables, their empirical distribution function $F_L$ satisfies

$$
 \Pr\!\left(\sup_{0\le u\le1}|F_L(u)-u|>v\right)\le2e^{-2Lv^2}
 \quad (v>0).
$$

This is the Dvoretzky–Kiefer–Wolfowitz inequality with Massart's constant. [Massart's theorem](https://doi.org/10.1214/aop/1176990746)

Under $\nu$, we have $F_L(Y_i)=(1+di)/L$ almost surely.
The maximum difference between $(1+di)/L$ and $t_i$ is at most $2/n$.
Indeed, both functions are affine in $i$, so checking the two endpoints suffices.
It follows that, for fixed $v>0$ and sufficiently large $n$,

$$
 \nu\!\left(\max_i|Y_i-t_i|>v\right)\le2e^{-Lv^2/2}.
$$

Apply (3). Its polynomial factor preserves exponential decay in $n$.
The inverse $f$ is uniformly continuous on $[0,1]$.
For every fixed $\eta>0$, we obtain

$$
 \Pr_{Q_n}\!\left(\max_i|x_i-f(t_i)|>\eta\right)\le C_\eta e^{-c_\eta n}.
 \tag{4}
$$

Let $R_i^Q$ be the rank of $X_i$ in the order induced by its labels.
Let $F_{M+r}$ be the empirical distribution function of all labels.
Conditioning on the order relations preserves its law, as shown in Section 1.
Because $R_i^Q/(M+r)=F_{M+r}(x_i)$, the same empirical inequality gives

$$
 \Pr_{Q_n}\!\left(\max_i \left|R_i^Q/(M+r)-x_i\right|>\eta\right)
 \le 2e^{-2(M+r)\eta^2}.
$$

A union bound with (4) proves (1) for $Q_n$, with denominator $M+r$.

## 4. Removal of the boundary vertices

Every extension of $P_n$ has a lift to $Q_n$.
Place the new lower chain first and the new upper chain last.
Every extension has at most $(M+r)!/M!\le(M+r)^r$ lifts.
Indeed, deleting the new vertices recovers its unique restriction, while arbitrary insertions give this upper bound.
Write $e(P_n)$ and $e(Q_n)$ for the extension counts.
Then $e(Q_n)/e(P_n)\le(M+r)^r$.

If $X_i$ has rank $k$ in an extension, its rank in any lift is $k+s$, with $0\le s\le r$.
Therefore

$$
 \left|\frac{k+s}{M+r}-\frac{k}{M}\right|\le\frac{r}{M+r}.
$$

For large $n$, every lift of a bad extension at tolerance $\varepsilon$ remains bad at tolerance $\varepsilon/2$.
Each bad extension has a lift, and different extensions have disjoint sets of lifts.
Hence

$$
 \Pr_{P_n}(\mathrm{bad}_{\varepsilon})\le
 \frac{e(Q_n)}{e(P_n)}\Pr_{Q_n}(\mathrm{bad}_{\varepsilon/2})
 \le (M+r)^r C_{\varepsilon/2}e^{-c_{\varepsilon/2}n}.
$$

The polynomial factor can be absorbed by decreasing the positive exponential rate.
Increasing the prefactor handles the finitely many smaller values of $n$. This proves (1).

## Proof status

The author selected the research direction and takes responsibility for this note.
Astra 6.2 developed the mathematics, wrote the text, and checked the argument in separate sessions.
The proof uses the boundary modification and beta substitution of Mitchell Lee and Ashwin Sah.
This note has a written proof. It has received no Lean verification or external referee review.
[Lee and Sah, Advances in Applied Mathematics (2019)](https://doi.org/10.1016/j.aam.2018.10.001)
