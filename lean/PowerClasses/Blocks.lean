import Std

namespace PackingBlocks

universe u v

structure Free {V : Type u} (fixed : V → V → Prop) (a b : V) : Prop where
  distinct : a ≠ b
  forward : ¬ fixed a b
  backward : ¬ fixed b a

theorem Free.symm {V : Type u} {r : V → V → Prop} {a b : V}
    (h : Free r a b) : Free r b a :=
  ⟨Ne.symm h.distinct, h.backward, h.forward⟩

structure Supported {V : Type u} {L : Type v}
    (r : V → V → Prop) (window : L → V → Prop) (i : L) (a b : V) : Prop where
  free : Free r a b
  left : window i a
  right : window i b

theorem Supported.symm {V : Type u} {L : Type v} {r : V → V → Prop}
    {W : L → V → Prop} {i : L} {a b : V}
    (h : Supported r W i a b) : Supported r W i b a :=
  ⟨h.free.symm, h.right, h.left⟩

structure Pick (V : Type u) (L : Type v) where
  label : L
  src : V
  dst : V

structure StrictOrder (V : Type u) where
  lt : V → V → Prop
  trans : ∀ {a b c}, lt a b → lt b c → lt a c
  irrefl : ∀ a, ¬ lt a a

/-- Each incomparable pair has one window. In distinct windows, one can
choose the orientation of any one supported pair independently. -/
structure Windows (V : Type u) (L : Type v) where
  fixed : V → V → Prop
  window : L → V → Prop
  cover : ∀ {a b}, Free fixed a b → ∃ i, window i a ∧ window i b
  uniqueLabel : ∀ {a b i j}, Free fixed a b →
    window i a → window i b → window j a → window j b → i = j
  realize : ∀ (req : List (Pick V L)),
    (req.map Pick.label).Nodup →
    (∀ p ∈ req, Supported fixed window p.label p.src p.dst) →
    ∃ o : StrictOrder V, (∀ a b, fixed a b → o.lt a b) ∧
      ∀ p ∈ req, o.lt p.src p.dst

variable {V : Type u} {L : Type v} (M : Windows V L)

private theorem excludeThird {i j : L} {a b c : V} (hne : i ≠ j)
    (ab : Supported M.fixed M.window i a b)
    (bc : Supported M.fixed M.window j b c) : ¬ M.fixed c a := by
  let p : Pick V L := ⟨i, a, b⟩
  let q : Pick V L := ⟨j, b, c⟩
  have labels : ([p, q].map Pick.label).Nodup := by simp [p, q, hne]
  have valid : ∀ s ∈ [p, q], Supported M.fixed M.window s.label s.src s.dst := by
    intro s hs
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hs
    rcases hs with h | h
    · subst s
      exact ab
    · subst s
      exact bc
  obtain ⟨o, ext, chosen⟩ := M.realize [p, q] labels valid
  have a_b : o.lt a b := chosen p (by simp)
  have b_c : o.lt b c := chosen q (by simp)
  intro ca
  exact o.irrefl a (o.trans (o.trans a_b b_c) (ext c a ca))

private theorem excludeCycle {i j k : L} {a b c : V}
    (hij : i ≠ j) (hik : i ≠ k) (hjk : j ≠ k)
    (ab : Supported M.fixed M.window i a b)
    (bc : Supported M.fixed M.window j b c)
    (ca : Supported M.fixed M.window k c a) : False := by
  let p : Pick V L := ⟨i, a, b⟩
  let q : Pick V L := ⟨j, b, c⟩
  let s : Pick V L := ⟨k, c, a⟩
  have labels : ([p, q, s].map Pick.label).Nodup := by simp [p, q, s, hij, hik, hjk]
  have valid : ∀ t ∈ [p, q, s], Supported M.fixed M.window t.label t.src t.dst := by
    intro t ht
    simp only [List.mem_cons, List.not_mem_nil, or_false] at ht
    rcases ht with h | h | h
    · subst t
      exact ab
    · subst t
      exact bc
    · subst t
      exact ca
  obtain ⟨o, _, chosen⟩ := M.realize [p, q, s] labels valid
  have a_b : o.lt a b := chosen p (by simp)
  have b_c : o.lt b c := chosen q (by simp)
  have c_a : o.lt c a := chosen s (by simp)
  exact o.irrefl a (o.trans (o.trans a_b b_c) c_a)

/-- Incomparable pairs with a common endpoint have the same window. -/
theorem incident_same_label {i j : L} {a b c : V}
    (ab : Supported M.fixed M.window i a b)
    (ac : Supported M.fixed M.window j a c) : i = j := by
  classical
  apply Classical.byContradiction
  intro hij
  have distinct : b ≠ c := by
    intro h
    subst c
    exact hij (M.uniqueLabel ab.free ab.left ab.right ac.left ac.right)
  have noBC := excludeThird M (Ne.symm hij) ac.symm ab
  have noCB := excludeThird M hij ab.symm ac
  have freeBC : Free M.fixed b c := ⟨distinct, noBC, noCB⟩
  obtain ⟨k, kb, kc⟩ := M.cover freeBC
  have bc : Supported M.fixed M.window k b c := ⟨freeBC, kb, kc⟩
  have hik : i ≠ k := by
    intro h
    subst k
    exact hij (M.uniqueLabel ac.free ab.left kc ac.left ac.right)
  have hkj : k ≠ j := by
    intro h
    subst k
    exact hij (M.uniqueLabel ab.free ab.left ab.right ac.left kb)
  exact excludeCycle M hik hij hkj ab bc ac.symm

inductive Walk {V : Type u} (r : V → V → Prop) : V → V → Prop where
  | nil (a) : Walk r a a
  | cons {a b c} : Free r a b → Walk r b c → Walk r a c

/-- Any two edges incident to vertices in one connected component
have the same label, including across a path of arbitrary length. -/
theorem component_same_label {a b : V} (path : Walk M.fixed a b) :
    ∀ {x y : V} {i j : L}, Supported M.fixed M.window i a x →
      Supported M.fixed M.window j b y → i = j := by
  induction path with
  | nil => exact fun start finish => incident_same_label M start finish
  | @cons a b c hab _ ih =>
    intro x y i j start finish
    obtain ⟨k, ka, kb⟩ := M.cover hab
    have link : Supported M.fixed M.window k a b := ⟨hab, ka, kb⟩
    exact (incident_same_label M start link).trans (ih link.symm finish)

/-- If each window has at most one unordered free pair, every vertex
has at most one incomparable neighbor in the whole order. -/
theorem unique_neighbor
    (single : ∀ {i : L} {a b c : V},
      Supported M.fixed M.window i a b → Supported M.fixed M.window i a c → b = c)
    {a b c : V} (ab : Free M.fixed a b) (ac : Free M.fixed a c) : b = c := by
  obtain ⟨i, ia, ib⟩ := M.cover ab
  obtain ⟨j, ja, jc⟩ := M.cover ac
  have p : Supported M.fixed M.window i a b := ⟨ab, ia, ib⟩
  have q : Supported M.fixed M.window j a c := ⟨ac, ja, jc⟩
  have h := incident_same_label M p q
  subst j
  exact single p q

#print axioms incident_same_label
#print axioms component_same_label
#print axioms unique_neighbor

end PackingBlocks
