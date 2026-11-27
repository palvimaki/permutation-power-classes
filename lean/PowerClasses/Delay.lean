import PowerClasses.DelayWitness

namespace Packing.Delay

abbrev TrackRelation := Track → Nat → Track → Nat → Prop

def TrackTransitive (R : TrackRelation) : Prop :=
  ∀ {s t u : Track} {i h k : Nat}, R s i t h → R t h u k → R s i u k

/-- Every comparison made inside one window must hold in R. -/
def LocalComparisons (a M : Nat) (R : TrackRelation) : Prop :=
  ∀ (s : Track) (i : Nat) (t : Track) (h : Nat), i ≤ M → h ≤ M →
    i ≤ h + a + 1 → h ≤ i + a + 1 →
    score a false s i < score a false t h → R s i t h

private theorem sameTrack {a M : Nat} {R : TrackRelation}
    (trans : TrackTransitive R) (loc : LocalComparisons a M R)
    (s : Track) (i h : Nat) : h ≤ M → i < h → R s i s h := by
  induction h with
  | zero => intro _ hlt; omega
  | succ h ih =>
    intro hh hlt
    have edge : R s h s (h + 1) := by
      apply loc s h s (h + 1) (by omega) hh (by omega) (by omega)
      cases s <;> simp [score] <;> omega
    by_cases he : i = h
    · subst i
      exact edge
    · exact trans (ih (by omega) (by omega)) edge

private theorem neighborTracks {a M : Nat} {R : TrackRelation}
    (trans : TrackTransitive R) (loc : LocalComparisons a M R) (s t : Track)
    (cut : ∀ i h : Nat,
      (score a false s i < score a false t h ↔ i ≤ h + a) ∧
      (score a false t h < score a false s i ↔ h + a < i)) :
    (∀ i h : Nat, i ≤ M → h ≤ M → i ≤ h + a → R s i t h) ∧
    (∀ i h : Nat, i ≤ M → h ≤ M → h + a < i → R t h s i) := by
  constructor
  · intro i h hi hh hc
    by_cases near : h ≤ i + a + 1
    · exact loc s i t h hi hh (by omega) near ((cut i h).1.mpr hc)
    · have ss := sameTrack (R := R) trans loc s i h hh (by omega)
      have st := loc s h t h hh hh (by omega) (by omega) ((cut h h).1.mpr (by omega))
      exact trans ss st
  · intro i h hi hh hc
    let k := h + a + 1
    have hk : k ≤ M := by dsimp [k]; omega
    have ts : R t h s k :=
      loc t h s k hh hk (by dsimp [k]; omega) (by dsimp [k]; omega)
        ((cut k h).2.mpr (by dsimp [k]; omega))
    by_cases eq : k = i
    · simpa only [eq] using ts
    · have ss := sameTrack (R := R) trans loc s k i hi (by dsimp [k] at *; omega)
      exact trans ts ss

/-- Every comparison in the first score order follows from a local comparison
or transitivity, except possibly Z_i < X_(i+2a+1). -/
theorem forceExceptMiddle {a M : Nat} {R : TrackRelation}
    (trans : TrackTransitive R) (loc : LocalComparisons a M R)
    (s : Track) (i : Nat) (t : Track) (h : Nat) (hi : i ≤ M) (hh : h ≤ M)
    (key : score a false s i < score a false t h)
    (outside : ¬ (s = .z ∧ t = .x ∧ h = i + 2*a + 1)) : R s i t h := by
  have cutXY (u v : Nat) :
      (score a false .x u < score a false .y v ↔ u ≤ v + a) ∧
      (score a false .y v < score a false .x u ↔ v + a < u) := by
    simp [score] <;> omega
  have cutYZ (u v : Nat) :
      (score a false .y u < score a false .z v ↔ u ≤ v + a) ∧
      (score a false .z v < score a false .y u ↔ v + a < u) := by
    simp [score] <;> omega
  have xy := neighborTracks (R := R) trans loc .x .y cutXY
  have yz := neighborTracks (R := R) trans loc .y .z cutYZ
  cases s <;> cases t
  · apply sameTrack (R := R) trans loc .x i h hh
    simp [score] at key
    omega
  · exact xy.1 i h hi hh ((cutXY i h).1.mp key)
  · have hc : i ≤ h + 2*a := by simp [score] at key; omega
    let k := i - a
    have hk : k ≤ M := by dsimp [k]; omega
    exact trans (xy.1 i k hi hk (by dsimp [k]; omega))
      (yz.1 k h hk hh (by dsimp [k]; omega))
  · exact xy.2 h i hh hi ((cutXY h i).2.mp key)
  · apply sameTrack (R := R) trans loc .y i h hh
    simp [score] at key
    omega
  · exact yz.1 i h hi hh ((cutYZ i h).1.mp key)
  · have hc : i + 2*a + 2 ≤ h := by
      simp [score] at key
      have he : h ≠ i + 2*a + 1 := fun e => outside ⟨rfl, rfl, e⟩
      omega
    let k := i + a + 1
    have hk : k ≤ M := by dsimp [k]; omega
    exact trans (yz.2 k i hk hi (by dsimp [k]; omega))
      (xy.2 h k hh hk (by dsimp [k]; omega))
  · exact yz.2 h i hh hi ((cutYZ h i).2.mp key)
  · apply sameTrack (R := R) trans loc .z i h hh
    simp [score] at key
    omega

/-- At most L−2 copies force every pair in the score order. -/
theorem shortPackingsForceComparisons {L j : Nat} (hL : 5 ≤ L)
    (_hj : 1 ≤ j) (hshort : j ≤ L - 2) {R : TrackRelation}
    (trans : TrackTransitive R) (loc : LocalComparisons (L - 2) (L + j - 2) R)
    (s : Track) (i : Nat) (t : Track) (h : Nat)
    (hi : i ≤ L + j - 2) (hh : h ≤ L + j - 2)
    (key : score (L - 2 : Nat) false s i < score (L - 2 : Nat) false t h) : R s i t h := by
  apply forceExceptMiddle (R := R) trans loc s i t h hi hh key
  intro ex
  have he := ex.2.2
  omega


/-- This hypothesis constrains only values within the finite windows. -/
def MatchesFiniteWindows (a l last : Int) (f : Track → Int → Int) : Prop :=
  ∀ w : Int, 0 ≤ w → w + l - 1 ≤ last →
    ∀ s i t h, 0 ≤ i → i < l → 0 ≤ h → h < l →
      (f s (w+i) < f t (w+h) ↔ precedes a false s i t h)

private theorem windowsForceNearby {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j)
    (f : Track → Int → Int)
    (windows : MatchesFiniteWindows (L - 2 : Nat) L (L + j - 2 : Nat) f) :
    LocalComparisons (L - 2) (L + j - 2) (fun s i t h => f s i < f t h) := by
  intro s i t h hi hh ihloc hiloc key
  have witness : ∃ w : Int, 0 ≤ w ∧ w + L - 1 ≤ (↑(L + j - 2 : Nat) : Int) ∧
      w ≤ i ∧ (i : Int) < w + L ∧ w ≤ h ∧ (h : Int) < w + L := by
    by_cases ord : i ≤ h
    · by_cases edge : h < L
      · refine ⟨0, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
      · refine ⟨(h : Int) - L + 1, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
    · by_cases edge : i < L
      · refine ⟨0, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
      · refine ⟨(i : Int) - L + 1, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
  obtain ⟨w, hw, hlast, wi, iw, wh, hw'⟩ := witness
  have ei : w + ((i : Int) - w) = i := by omega
  have eh : w + ((h : Int) - w) = h := by omega
  have shiftI := shift_score (↑(L - 2 : Nat)) w false s ((i : Int) - w)
  have shiftH := shift_score (↑(L - 2 : Nat)) w false t ((h : Int) - w)
  rw [ei] at shiftI
  rw [eh] at shiftH
  have shifted : precedes (↑(L - 2 : Nat)) false s ((i : Int) - w) t ((h : Int) - w) := by
    unfold precedes
    omega
  have result := (windows w hw hlast s ((i : Int) - w) t ((h : Int) - w)
    (by omega) (by omega) (by omega) (by omega)).mpr shifted
  simpa only [ei, eh] using result

/-- Every realization of the finite windows gives the canonical comparison
on every pair of positions. The definition tests no values outside the windows. -/
def UniqueWindowOrder (L j : Nat) : Prop :=
  ∀ f : Track → Int → Int, MatchesFiniteWindows (L - 2 : Nat) L (L + j - 2 : Nat) f →
    ∀ (s : Track) (i : Nat) (t : Track) (h : Nat), i ≤ L + j - 2 → h ≤ L + j - 2 →
      (f s i < f t h ↔ score (L - 2 : Nat) false s i < score (L - 2 : Nat) false t h)

theorem uniqueWindowOrder_iff {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j) :
    UniqueWindowOrder L j ↔ j ≤ L - 2 := by
  constructor
  · intro unique
    by_cases short : j ≤ L - 2
    · exact short
    exfalso
    have hv := realizes_windows (↑(L - 2 : Nat)) (↑L) (↑(L + j - 2 : Nat))
      (by omega) (by omega) true
    have flip : score (L - 2 : Nat) true .x (↑(2 * (L - 2) + 1 : Nat)) <
        score (L - 2 : Nat) true .z 0 := by
      simp [score] <;> omega
    have impossible := (unique (score (L - 2 : Nat) true) hv.2 .x (2*(L-2)+1) .z 0
      (by omega) (by omega)).mp flip
    simp [score] at impossible
    omega
  · intro short f hw
    have loc := windowsForceNearby hL hj f hw
    have trans : TrackTransitive (fun s i t h => f s i < f t h) := by
      intro s t u i h k eq1 eq2
      exact Int.lt_trans eq1 eq2
    have forced := shortPackingsForceComparisons (R := fun s i t h => f s i < f t h) hL hj short trans loc
    intro s i t h hi hh
    constructor
    · intro less
      by_cases orient : score (L - 2 : Nat) false s i < score (L - 2 : Nat) false t h
      · exact orient
      · by_cases ties : score (L - 2 : Nat) false s i = score (L - 2 : Nat) false t h
        · obtain ⟨st, ih⟩ := (score_eq_iff _ _ _ _ _ _).mp ties
          have sameIndex : i = h := by omega
          subst t
          subst h
          omega
        · have back := forced t h s i hh hi (by omega)
          change f t h < f s i at back
          omega
    · exact forced s i t h hi hh

end Packing.Delay
