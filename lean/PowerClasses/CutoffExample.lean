import PowerClasses.Permutations

namespace Packing.Delay

/-- An increasing pattern of length 3L has window starts 0,3,...,3(j−1).
A permutation lists the physical positions in increasing order of their assigned ranks. -/
def IncreasingPacking (L j : Nat) (w : List Nat) : Prop :=
  w.Perm (List.range (3*(L+j-2+1))) ∧
  ∀ k, k < j → ∀ x y, 3*k ≤ x → x < y → y < 3*k+3*L → w.idxOf x < w.idxOf y

private theorem index_range {x n : Nat} (hx : x < n) : (List.range n).idxOf x = x := by
  have h : x < (List.range n).length := by simpa using hx
  simpa using (List.nodup_range (n := n)).idxOf_getElem x h

private theorem increasing_unique {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j) :
    ∃ w, IncreasingPacking L j w ∧ ∀ v, IncreasingPacking L j v → v = w := by
  let n := 3*(L+j-2+1)
  refine ⟨List.range n, ⟨.refl _, ?_⟩, ?_⟩
  · intro k hk x y _ hxy hy
    rw [index_range (show x < n by dsimp [n]; omega), index_range (show y < n by dsimp [n]; omega)]
    exact hxy
  · intro v hv
    have adj (x : Nat) (hx : x+1 < n) : v.idxOf x < v.idxOf (x+1) := by
      let k := min (x/3) (j-1)
      apply hv.2 k (by dsimp [k]; omega) x (x+1) (by dsimp [k]; omega) (by omega)
      dsimp [k,n] at *
      omega
    have inc (y : Nat) : ∀ x, x < y → y < n → v.idxOf x < v.idxOf y := by
      induction y with
      | zero => omega
      | succ y ih =>
        intro x hxy hyn
        by_cases e : x = y
        · subst x
          exact adj y hyn
        · exact Nat.lt_trans (ih x (by omega) (by omega)) (adj y hyn)
    have pn := hv.1.nodup_iff.mpr List.nodup_range
    have sorted : v.Pairwise (· < ·) := by
      apply List.pairwise_iff_getElem.mpr
      intro a b ha hb hab
      have ma : v[a] < n := List.mem_range.mp (hv.1.subset (List.getElem_mem ha))
      have neq : v[a] ≠ v[b] := by
        intro e
        have := pn.eq_of_getElem_eq ha hb e
        omega
      by_cases bad : v[b] < v[a]
      · have back := inc v[a] v[b] bad ma
        rw [pn.idxOf_getElem, pn.idxOf_getElem] at back
        omega
      · omega
    exact List.Perm.eq_of_pairwise (fun _ _ _ _ ab ba => False.elim (Nat.lt_asymm ab ba))
      sorted List.pairwise_lt_range hv.1

/-- Equinumerosity means that the two sets of packing permutations admit inverse maps. -/
def SameCount {α β : Type} (P : α → Prop) (Q : β → Prop) : Prop :=
  ∃ f : Subtype P → Subtype Q, ∃ g : Subtype Q → Subtype P,
    (∀ x, g (f x) = x) ∧ (∀ y, f (g y) = y)

private theorem same_count_singleton {α β : Type} {P : α → Prop} {Q : β → Prop}
    (inh : ∃ p, P p) (uniq : ∃ q, Q q ∧ ∀ v, Q v → v = q) :
    SameCount P Q ↔ ∃ p, P p ∧ ∀ v, P v → v = p := by
  obtain ⟨q, hq, onlyQ⟩ := uniq
  constructor
  · rintro ⟨f, g, left, _⟩
    obtain ⟨p,hp⟩ := inh
    refine ⟨p,hp,?_⟩
    intro v hv
    let a : Subtype P := ⟨v,hv⟩
    let b : Subtype P := ⟨p,hp⟩
    have fe : f a = f b := Subtype.ext ((onlyQ _ (f a).property).trans (onlyQ _ (f b).property).symm)
    exact congrArg Subtype.val ((left a).symm.trans ((congrArg g fe).trans (left b)))
  · rintro ⟨p,hp,onlyP⟩
    refine ⟨fun _ => ⟨q,hq⟩, fun _ => ⟨p,hp⟩, ?_, ?_⟩
    · exact fun x => Subtype.ext (onlyP _ x.property).symm
    · exact fun x => Subtype.ext (onlyQ _ x.property).symm

theorem same_count_iff {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j) :
    SameCount (IsPacking L j) (IncreasingPacking L j) ↔ j ≤ L-2 := by
  exact (same_count_singleton (packing_exists hL hj) (increasing_unique hL hj)).trans
    (unique_permutation_iff hL hj)

/-- For each proposed cutoff C, two patterns of the same length and overlap agree
through C copies and differ later. Both statements use actual finite permutation lists. -/
theorem no_absolute_wilf_cutoff (C : Nat) :
    ∃ L j, 5 ≤ L ∧ C < j ∧
      (∀ i, 1 ≤ i → i ≤ C → SameCount (IsPacking L i) (IncreasingPacking L i)) ∧
      ¬ SameCount (IsPacking L j) (IncreasingPacking L j) := by
  refine ⟨C+5, C+4, by omega, by omega, ?_, ?_⟩
  · exact fun i hi h => (same_count_iff (by omega) hi).mpr (by omega)
  · intro h
    have := (same_count_iff (by omega) (by omega)).mp h
    omega

end Packing.Delay
