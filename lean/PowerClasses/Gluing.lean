import Std

namespace PowerPacking.Gluing

universe u v w

/-- One local order contains private entries and entries on the common chain. -/
inductive Entry (A : Type u) (S : Type v) where
  | own (a : A)
  | shared (s : S)

/-- The merged order distinguishes left-private, shared, and right-private entries. -/
inductive Joined (A : Type u) (B : Type v) (S : Type w) where
  | left (a : A)
  | shared (s : S)
  | right (b : B)

variable {A : Type u} {B : Type v} {S : Type w}

def common : List (Entry A S) → List S
  | [] => []
  | .own _ :: tail => common tail
  | .shared s :: tail => s :: common tail

def leftOrder : List (Joined A B S) → List (Entry A S)
  | [] => []
  | .left a :: tail => .own a :: leftOrder tail
  | .shared s :: tail => .shared s :: leftOrder tail
  | .right _ :: tail => leftOrder tail

def rightOrder : List (Joined A B S) → List (Entry B S)
  | [] => []
  | .left _ :: tail => rightOrder tail
  | .shared s :: tail => .shared s :: rightOrder tail
  | .right b :: tail => .own b :: rightOrder tail

/-- Equal common projections suffice to realize both local orders simultaneously.
The statement also permits repeated entries. In particular, it applies to orders
that list each position exactly once. -/
theorem merge_orders (xs : List (Entry A S)) (ys : List (Entry B S))
    (agree : common xs = common ys) :
    ∃ zs : List (Joined A B S), leftOrder zs = xs ∧ rightOrder zs = ys := by
  induction xs generalizing ys with
  | nil =>
    induction ys with
    | nil => exact ⟨[], rfl, rfl⟩
    | cons y ys ih =>
      cases y with
      | own b =>
        obtain ⟨zs, hl, hr⟩ := ih agree
        exact ⟨.right b :: zs, hl, by simp [rightOrder, hr]⟩
      | shared s => simp [common] at agree
  | cons x xs ih =>
    cases x with
    | own a =>
      obtain ⟨zs, hl, hr⟩ := ih ys agree
      exact ⟨.left a :: zs, by simp [leftOrder, hl], hr⟩
    | shared s =>
      induction ys with
      | nil => simp [common] at agree
      | cons y ys ihy =>
        cases y with
        | own b =>
          obtain ⟨zs, hl, hr⟩ := ihy agree
          exact ⟨.right b :: zs, hl, by simp [rightOrder, hr]⟩
        | shared t =>
          change s :: common xs = t :: common ys at agree
          obtain ⟨hst, htail⟩ := List.cons.inj agree
          subst t
          obtain ⟨zs, hl, hr⟩ := ih ys htail
          exact ⟨.shared s :: zs, by simp [leftOrder, hl], by simp [rightOrder, hr]⟩

#print axioms merge_orders

end PowerPacking.Gluing
