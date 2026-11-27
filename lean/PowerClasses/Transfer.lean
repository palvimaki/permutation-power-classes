import Std

namespace PowerClasses.Transfer

abbrev Rank := Nat
abbrev Shared := List (Rank × Rank)
abbrev Vertex := Nat × Rank

/-- Each shared entry gives its rank in the new window, then its rank in the old window. -/
def Admissible (g : Shared) : Prop :=
  ∀ a ∈ g, ∀ b ∈ g, a.1 ≤ b.1 ↔ a.2 ≤ b.2

def lower (z : Rank) : Shared → Rank
  | [] => 0
  | (p, q) :: gs => if q ≤ z then max p (lower z gs) else lower z gs

def upper (top z : Rank) : Shared → Rank
  | [] => top
  | (p, q) :: gs => if z ≤ q then min p (upper top z gs) else upper top z gs

def boundary (f : Rank → Rank) (x : Rank) : Nat → Rank
  | 0 => x
  | n + 1 => f (boundary f x n)

/-- Adjacent windows identify their shared ranks in both directions. -/
inductive Step (g : Shared) : Vertex → Vertex → Prop
  | within (n x y : Nat) (h : x ≤ y) : Step g (n, x) (n, y)
  | forward (n : Nat) (a : Rank × Rank) (mem : a ∈ g) : Step g (n, a.2) (n+1, a.1)
  | backward (n : Nat) (a : Rank × Rank) (mem : a ∈ g) : Step g (n+1, a.1) (n, a.2)

inductive Path (g : Shared) : Vertex → Vertex → Prop
  | refl (u : Vertex) : Path g u u
  | tail {u v w : Vertex} (pre : Path g u v) (edge : Step g v w) : Path g u w

private theorem single {g : Shared} {u v : Vertex} (e : Step g u v) : Path g u v :=
  .tail (.refl u) e

private theorem concat {g : Shared} {u v w : Vertex} (a : Path g u v) (b : Path g v w) :
    Path g u w := by
  induction b with
  | refl => exact a
  | tail _ e ih => exact .tail ih e

private theorem lower_witness (g : Shared) (y z : Rank) (hy : 0 < y) :
    y ≤ lower z g ↔ ∃ a ∈ g, y ≤ a.1 ∧ a.2 ≤ z := by
  induction g with
  | nil => simp [lower, Nat.not_le.mpr hy]
  | cons a g ih =>
    rcases a with ⟨p, q⟩
    simp only [lower, List.mem_cons]
    by_cases hq : q ≤ z
    · have split : y ≤ max p (lower z g) ↔ y ≤ p ∨ y ≤ lower z g := by grind
      simp only [hq, ite_true]
      rw [split, ih]
      constructor
      · rintro (h | ⟨a, ha, h⟩)
        · exact ⟨(p,q), Or.inl rfl, h, hq⟩
        · exact ⟨a, Or.inr ha, h⟩
      · rintro ⟨a, rfl | ha, h, hz⟩
        · exact Or.inl h
        · exact Or.inr ⟨a, ha, h, hz⟩
    · simp only [hq, ite_false]
      rw [ih]
      constructor
      · rintro ⟨a, ha, h⟩
        exact ⟨a, Or.inr ha, h⟩
      · rintro ⟨a, rfl | ha, h, hz⟩
        · exact False.elim (hq hz)
        · exact ⟨a, ha, h, hz⟩

private theorem upper_witness (g : Shared) (top y z : Rank) (hy : y < top) :
    upper top z g ≤ y ↔ ∃ a ∈ g, a.1 ≤ y ∧ z ≤ a.2 := by
  induction g with
  | nil => simp [upper, Nat.not_le.mpr hy]
  | cons a g ih =>
    rcases a with ⟨p, q⟩
    simp only [upper, List.mem_cons]
    by_cases hq : z ≤ q
    · have split : min p (upper top z g) ≤ y ↔ p ≤ y ∨ upper top z g ≤ y := by grind
      simp only [hq, ite_true]
      rw [split, ih]
      constructor
      · rintro (h | ⟨a, ha, h⟩)
        · exact ⟨(p,q), Or.inl rfl, h, hq⟩
        · exact ⟨a, Or.inr ha, h⟩
      · rintro ⟨a, rfl | ha, h, hz⟩
        · exact Or.inl h
        · exact Or.inr ⟨a, ha, h, hz⟩
    · simp only [hq, ite_false]
      rw [ih]
      constructor
      · rintro ⟨a, ha, h⟩
        exact ⟨a, Or.inr ha, h⟩
      · rintro ⟨a, rfl | ha, h, hz⟩
        · exact False.elim (hq hz)
        · exact ⟨a, ha, h, hz⟩

private theorem lower_shared {g : Shared} (adm : Admissible g) {a : Rank × Rank}
    (ha : a ∈ g) (hp : 0 < a.1) (z : Rank) : a.1 ≤ lower z g ↔ a.2 ≤ z := by
  rw [lower_witness g a.1 z hp]
  constructor
  · rintro ⟨b, hb, hab, hq⟩
    exact Nat.le_trans ((adm a ha b hb).mp hab) hq
  · exact fun h => ⟨a, ha, Nat.le_refl _, h⟩

private theorem upper_shared {g : Shared} (adm : Admissible g) {a : Rank × Rank}
    (ha : a ∈ g) {top : Rank} (hp : a.1 < top) (z : Rank) : upper top z g ≤ a.1 ↔ z ≤ a.2 := by
  rw [upper_witness g top a.1 z hp]
  constructor
  · rintro ⟨b, hb, hab, hq⟩
    exact Nat.le_trans hq ((adm b hb a ha).mp hab)
  · exact fun h => ⟨a, ha, Nat.le_refl _, h⟩

private theorem down_closed {g : Shared} (adm : Admissible g)
    (pos : ∀ a ∈ g, 0 < a.1) (x : Rank) {u v : Vertex} (path : Path g u v) :
    v.2 ≤ boundary (fun z => lower z g) x v.1 → u.2 ≤ boundary (fun z => lower z g) x u.1 := by
  induction path with
  | refl => exact id
  | tail _ edge ih =>
    intro hv
    apply ih
    cases edge with
    | within _ _ _ h => exact Nat.le_trans h hv
    | forward n a ha => exact (lower_shared adm ha (pos a ha) _).mp hv
    | backward n a ha => exact (lower_shared adm ha (pos a ha) _).mpr hv

private theorem up_closed {g : Shared} (adm : Admissible g) (top : Rank)
    (below : ∀ a ∈ g, a.1 < top) (x : Rank) {u v : Vertex} (path : Path g u v) :
    boundary (fun z => upper top z g) x u.1 ≤ u.2 → boundary (fun z => upper top z g) x v.1 ≤ v.2 := by
  induction path with
  | refl => exact id
  | tail _ edge ih =>
    intro hu
    have hv := ih hu
    cases edge with
    | within _ _ _ h => exact Nat.le_trans hv h
    | forward n a ha => exact (upper_shared adm ha (below a ha) _).mpr hv
    | backward n a ha => exact (upper_shared adm ha (below a ha) _).mp hv

/-- Allow paths to cross shared positions repeatedly, in either direction. -/
theorem path_to_start_iff {g : Shared} (adm : Admissible g)
    (pos : ∀ a ∈ g, 0 < a.1 ∧ 0 < a.2) (x t y : Nat) (hy : 0 < y) :
    Path g (t,y) (0,x) ↔ y ≤ boundary (fun z => lower z g) x t := by
  constructor
  · exact fun h => down_closed adm (fun a ha => (pos a ha).1) x h (Nat.le_refl _)
  · induction t generalizing y with
    | zero => exact fun h => single (.within 0 y x h)
    | succ n ih =>
      intro bound
      obtain ⟨a, ha, hp, hq⟩ := (lower_witness g y _ hy).mp bound
      exact concat (.tail (single (.within (n+1) y a.1 hp)) (.backward n a ha))
        (ih a.2 (pos a ha).2 hq)

theorem path_from_start_iff {g : Shared} (adm : Admissible g) (top : Rank)
    (below : ∀ a ∈ g, a.1 < top ∧ a.2 < top) (x t y : Nat) (hy : y < top) :
    Path g (0,x) (t,y) ↔ boundary (fun z => upper top z g) x t ≤ y := by
  constructor
  · exact fun h => up_closed adm top (fun a ha => (below a ha).1) x h (Nat.le_refl _)
  · induction t generalizing y with
    | zero => exact fun h => single (.within 0 x y h)
    | succ n ih =>
      intro bound
      obtain ⟨a, ha, hp, hq⟩ := (upper_witness g top y _ hy).mp bound
      exact .tail (.tail (ih a.2 (below a ha).2 hq) (.forward n a ha)) (.within (n+1) a.1 y hp)

end PowerClasses.Transfer
