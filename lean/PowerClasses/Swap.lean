import Std

namespace PowerPacking.Swap

universe u v
variable {α : Type u} {ι : Type v}

/-- A list respects the strict order when no later entry must precede an earlier entry. -/
def Respects (r : α → α → Prop) (l : List α) : Prop :=
  l.Pairwise (fun a b => ¬ r b a)

/-- Interchanging adjacent incomparable entries preserves every required comparison. -/
theorem swap_respects (r : α → α → Prop) (pre post : List α) (a b : α)
    (hab : ¬ r a b)
    (h : Respects r (pre ++ a :: b :: post)) :
    Respects r (pre ++ b :: a :: post) := by
  simp only [Respects, List.pairwise_append, List.pairwise_cons,
    List.mem_cons, forall_eq_or_imp] at h ⊢
  grind

/-- A projection cannot see this interchange when it omits either entry. -/
theorem swap_projection (keep : α → Bool) (pre post : List α) (a b : α)
    (h : ¬ (keep a = true ∧ keep b = true)) :
    (pre ++ a :: b :: post).filter keep = (pre ++ b :: a :: post).filter keep := by
  cases ha : keep a <;> cases hb : keep b <;> simp_all

/-- The lists remain distinct even when the pair has a nonempty prefix. -/
theorem swap_distinct (pre post : List α) {a b : α} (hne : a ≠ b) :
    pre ++ a :: b :: post ≠ pre ++ b :: a :: post := by
  induction pre with
  | nil => simp [hne]
  | cons x xs ih => simpa using ih

/-- An invisible adjacent swap prevents unique reconstruction from all the projections. -/
theorem swap_witness (r : α → α → Prop) (view : ι → α → Bool)
    (pre post : List α) (a b : α) (hne : a ≠ b) (hab : ¬ r a b)
    (h : Respects r (pre ++ a :: b :: post))
    (hidden : ∀ i, ¬ (view i a = true ∧ view i b = true)) :
    Respects r (pre ++ b :: a :: post) ∧
    pre ++ a :: b :: post ≠ pre ++ b :: a :: post ∧
    ∀ i, (pre ++ a :: b :: post).filter (view i) =
      (pre ++ b :: a :: post).filter (view i) :=
  ⟨swap_respects r pre post a b hab h, swap_distinct pre post hne,
    fun i => swap_projection (view i) pre post a b (hidden i)⟩


/-- This definition enforces coverage, unique entries, and every order comparison. -/
def Extension (r : α → α → Prop) (l : List α) : Prop :=
  (∀ x, x ∈ l) ∧ Respects (fun x y => x = y ∨ r x y) l

/-- Put all strict predecessors of an incomparable pair first.
An existing extension orders the predecessors and the remaining entries. -/
theorem ideal_adjacent (r : α → α → Prop)
    (trans : ∀ {x y z}, r x y → r y z → r x z) (irrefl : ∀ x, ¬ r x x)
    (s : List α) (hs : Extension r s) (a b : α) (hne : a ≠ b)
    (hab : ¬ r a b) (hba : ¬ r b a) :
    ∃ pre post : List α, Extension r (pre ++ a :: b :: post) := by
  classical
  let ideal := fun x => r x a ∨ r x b
  let rest := fun x => x ≠ a ∧ x ≠ b ∧ ¬ ideal x
  let pre := s.filter (fun x => decide (ideal x))
  let post := s.filter (fun x => decide (rest x))
  have preMem (x : α) : x ∈ pre ↔ ideal x := by simp [pre, hs.1 x]
  have postMem (x : α) : x ∈ post ↔ rest x := by simp [post, hs.1 x]
  have ia : ¬ ideal a := by simp [ideal, irrefl, hab]
  have ib : ¬ ideal b := by simp [ideal, irrefl, hba]
  have closed {x y : α} (hx : ideal x) (hyx : r y x) : ideal y := by
    exact hx.elim (fun h => Or.inl (trans hyx h)) (fun h => Or.inr (trans hyx h))
  have cross {x y : α} (hx : ideal x) (hy : ¬ideal y) : ¬(y = x ∨ r y x) := by
    rintro (rfl | h)
    · exact hy hx
    · exact hy (closed hx h)
  have afterA {x : α} (hx : x ∈ post) : ¬(x = a ∨ r x a) := by
    obtain ⟨hna, _, hout⟩ := (postMem x).mp hx
    exact fun h => h.elim hna (fun hxa => hout (Or.inl hxa))
  have afterB {x : α} (hx : x ∈ post) : ¬(x = b ∨ r x b) := by
    obtain ⟨_, hnb, hout⟩ := (postMem x).mp hx
    exact fun h => h.elim hnb (fun hxb => hout (Or.inr hxb))
  have sGood : s.Pairwise (fun x y => ¬(y = x ∨ r y x)) := hs.2
  refine ⟨pre, post, ?_, ?_⟩
  · intro x
    simp only [List.mem_append, List.mem_cons, preMem, postMem]
    by_cases hi : ideal x
    · exact Or.inl hi
    by_cases ha : x = a
    · exact Or.inr (Or.inl ha)
    by_cases hb : x = b
    · exact Or.inr (Or.inr (Or.inl hb))
    exact Or.inr (Or.inr (Or.inr ⟨ha, hb, hi⟩))
  · apply List.pairwise_append.mpr
    refine ⟨sGood.filter _, ?_, ?_⟩
    · apply List.pairwise_cons.mpr
      constructor
      · intro y hy
        rcases List.mem_cons.mp hy with rfl | h
        · exact fun e => e.elim (Ne.symm hne) hba
        · exact afterA h
      · exact List.pairwise_cons.mpr ⟨fun _ h => afterB h, sGood.filter _⟩
    · intro x hx y hy
      have inIdeal := (preMem x).mp hx
      rcases List.mem_cons.mp hy with rfl | ht
      · exact cross inIdeal ia
      rcases List.mem_cons.mp ht with rfl | ht
      · exact cross inIdeal ib
      · exact cross inIdeal ((postMem y).mp ht).2.2

/-- If all views miss an incomparable pair, two extensions have the same views. -/
theorem missing_pair (r : α → α → Prop) (view : ι → α → Bool)
    (trans : ∀ {x y z}, r x y → r y z → r x z) (irrefl : ∀ x, ¬ r x x)
    (s : List α) (hs : Extension r s) (a b : α) (hne : a ≠ b)
    (hab : ¬ r a b) (hba : ¬ r b a)
    (hidden : ∀ i, ¬ (view i a = true ∧ view i b = true)) :
    ∃ xs ys : List α, Extension r xs ∧ Extension r ys ∧ xs ≠ ys ∧
      ∀ i, xs.filter (view i) = ys.filter (view i) := by
  obtain ⟨pre, post, hext⟩ := ideal_adjacent r trans irrefl s hs a b hne hab hba
  obtain ⟨hgood, hne', hview⟩ := swap_witness (fun x y => x = y ∨ r x y) view
    pre post a b hne (fun h => h.elim hne hab) hext.2 hidden
  refine ⟨_, _, hext, ⟨?_, hgood⟩, hne', hview⟩
  intro x
  have h := hext.1 x
  simp only [List.mem_append, List.mem_cons] at h ⊢
  grind

#print axioms missing_pair


/-- Restrictions distinguish different extensions if some view contains every
incomparable pair. Different first entries supply the pair in the induction. -/
theorem reconstruct (r : α → α → Prop) (view : ι → α → Bool)
    (cover : ∀ a b, a ≠ b → ¬ r a b → ¬ r b a →
      ∃ i, view i a = true ∧ view i b = true)
    (xs ys : List α)
    (hx : Respects (fun x y => x = y ∨ r x y) xs)
    (hy : Respects (fun x y => x = y ∨ r x y) ys)
    (same : ∀ x, x ∈ xs ↔ x ∈ ys)
    (observed : ∀ i, xs.filter (view i) = ys.filter (view i)) : xs = ys := by
  classical
  induction xs generalizing ys with
  | nil =>
    cases ys with
    | nil => rfl
    | cons b ys =>
      have impossible : b ∈ ([] : List α) := (same b).mpr (by simp)
      simp at impossible
  | cons a xs ih =>
    cases ys with
    | nil =>
      have impossible : a ∈ ([] : List α) := (same a).mp (by simp)
      simp at impossible
    | cons b ys =>
      obtain ⟨firstA, tailA⟩ := List.pairwise_cons.mp hx
      obtain ⟨firstB, tailB⟩ := List.pairwise_cons.mp hy
      by_cases h : a = b
      · subst b
        apply congrArg (List.cons a)
        apply ih (ys := ys) tailA tailB
        · intro x
          by_cases heq : x = a
          · subst x
            have left : a ∉ xs := fun ha => firstA a ha (Or.inl rfl)
            have right : a ∉ ys := fun ha => firstB a ha (Or.inl rfl)
            simp [left, right]
          · simpa [List.mem_cons, heq] using same x
        · intro i
          cases hv : view i a <;> simpa [List.filter_cons, hv] using observed i
      · have ba : b ∈ xs := by
          have hmem := (same b).mpr (by simp)
          simpa [List.mem_cons, Ne.symm h] using hmem
        have ab : a ∈ ys := by
          have hmem := (same a).mp (by simp)
          simpa [List.mem_cons, h] using hmem
        obtain ⟨i, visibleA, visibleB⟩ := cover a b h
          (fun rel => firstB a ab (Or.inr rel)) (fun rel => firstA b ba (Or.inr rel))
        have eqcons : a :: xs.filter (view i) = b :: ys.filter (view i) := by
          simpa [List.filter_cons, visibleA, visibleB] using observed i
        exact (h (List.cons.inj eqcons).1).elim

/-- Full abstract equality criterion. The input lists represent all finite
linear extensions. The views are arbitrary subsets of the underlying set. -/
theorem projection_injective_iff (r : α → α → Prop) (view : ι → α → Bool)
    (trans : ∀ {x y z}, r x y → r y z → r x z) (irrefl : ∀ x, ¬ r x x)
    (s : List α) (hs : Extension r s) :
    (∀ xs ys : List α, Extension r xs → Extension r ys →
      (∀ i, xs.filter (view i) = ys.filter (view i)) → xs = ys) ↔
    (∀ a b, a ≠ b → ¬ r a b → ¬ r b a → ∃ i, view i a = true ∧ view i b = true) := by
  classical
  constructor
  · intro h a b hne hab hba
    apply Classical.byContradiction
    intro hmiss
    obtain ⟨xs, ys, hx, hy, different, observed⟩ :=
      missing_pair r view trans irrefl s hs a b hne hab hba (fun i both => hmiss ⟨i, both⟩)
    exact different (h xs ys hx hy observed)
  · intro cover xs ys hx hy observed
    exact reconstruct r view cover xs ys hx.2 hy.2 (fun x => ⟨fun _ => hy.1 x, fun _ => hx.1 x⟩) observed

#print axioms projection_injective_iff

end PowerPacking.Swap
