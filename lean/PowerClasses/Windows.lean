import Std

namespace PowerClasses

/-- Position membership for the window with zero-based start r * d. -/
def InWindow (d K r x : Nat) : Prop := r * d ≤ x ∧ x < r * d + K

/-- The new window meets the earlier union exactly where it meets the last window. -/
theorem sharedWithPast (d K r x : Nat) :
    ((∃ i, i ≤ r ∧ InWindow d K i x) ∧ InWindow d K (r + 1) x) ↔
      (InWindow d K r x ∧ InWindow d K (r + 1) x) := by
  constructor
  · rintro ⟨⟨i, hir, hix⟩, hx⟩
    have hle := Nat.mul_le_mul_right d hir
    have hstart := Nat.mul_le_mul_right d (Nat.le_succ r)
    exact ⟨⟨Nat.le_trans hstart hx.1, Nat.lt_of_lt_of_le hix.2 (Nat.add_le_add_right hle K)⟩, hx⟩
  · rintro ⟨hr, hn⟩
    exact ⟨⟨r, Nat.le_refl r, hr⟩, hn⟩

end PowerClasses
