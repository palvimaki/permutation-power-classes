import PowerClasses.Delay

namespace Packing.Delay

abbrev Position := Track × Nat

/-- The three labelled positions at each time occur exactly once. -/
def positions : Nat → List Position
  | 0 => []
  | n+1 => (.x,n) :: (.y,n) :: (.z,n) :: positions n

private theorem mem_positions (s : Track) (i n : Nat) : (s,i) ∈ positions n ↔ i < n := by
  induction n with
  | zero => simp [positions]
  | succ n ih =>
    cases s <;> simp_all [positions] <;> omega

private theorem positions_nodup (n : Nat) : (positions n).Nodup := by
  induction n with
  | zero => simp [positions]
  | succ n ih => simp [positions, List.nodup_cons, mem_positions, ih]

def rankIn (w : List Position) (s : Track) (i : Int) : Int := w.idxOf (s, i.toNat)

/-- A permutation lists physical positions by increasing rank.
Its ranks must match the prescribed pattern in every window. -/
def IsPacking (L j : Nat) (w : List Position) : Prop :=
  w.Perm (positions (L+j-2+1)) ∧
  MatchesFiniteWindows (L-2 : Nat) L (L+j-2 : Nat) (rankIn w)

private def value (a : Int) (b : Bool) (p : Position) : Int := score a b p.1 p.2

private theorem value_inj (a : Int) (b : Bool) (p q : Position) :
    value a b p = value a b q → p = q := by
  rcases p with ⟨s,i⟩
  rcases q with ⟨t,h⟩
  intro eqv
  obtain ⟨rfl, ih⟩ := (score_eq_iff a b s i t h).mp eqv
  have : i = h := by omega
  subst h
  rfl

private def orderWord (a : Int) (b : Bool) (n : Nat) : List Position :=
  (positions n).mergeSort (fun p q => decide (value a b p ≤ value a b q))

private theorem word_perm (a : Int) (b : Bool) (n : Nat) :
    (orderWord a b n).Perm (positions n) := List.mergeSort_perm _ _

private theorem word_sorted (a : Int) (b : Bool) (n : Nat) :
    (orderWord a b n).Pairwise (fun p q => value a b p ≤ value a b q) := by
  unfold orderWord
  have sorted := List.pairwise_mergeSort (le := fun p q => decide (value a b p ≤ value a b q))
    (by intro p q r; simp; omega) (by intro p q; simp; omega) (positions n)
  simpa using sorted

private theorem idx_order (a : Int) (b : Bool) (n : Nat) (p q : Position)
    (hp : p ∈ positions n) (hq : q ∈ positions n) :
    (orderWord a b n).idxOf p < (orderWord a b n).idxOf q ↔ value a b p < value a b q := by
  let w := orderWord a b n
  have wp : p ∈ w := (word_perm a b n).symm.subset hp
  have wq : q ∈ w := (word_perm a b n).symm.subset hq
  have ip := List.idxOf_lt_length_of_mem wp
  have iq := List.idxOf_lt_length_of_mem wq
  have ep := List.getElem_idxOf ip
  have eq := List.getElem_idxOf iq
  have sorted := List.pairwise_iff_getElem.mp (word_sorted a b n)
  have weak (p q : Position) (hp : p ∈ w) (hq : q ∈ w) (h : w.idxOf p < w.idxOf q) :
      value a b p < value a b q := by
    have hp' := List.idxOf_lt_length_of_mem hp
    have hq' := List.idxOf_lt_length_of_mem hq
    have le := sorted (w.idxOf p) (w.idxOf q) hp' hq' h
    change value a b w[w.idxOf p] ≤ value a b w[w.idxOf q] at le
    rw [List.getElem_idxOf hp', List.getElem_idxOf hq'] at le
    have ne : value a b p ≠ value a b q := by
      intro e
      have := value_inj a b p q e
      subst q
      omega
    omega
  constructor
  · exact weak p q wp wq
  · intro h
    change w.idxOf p < w.idxOf q
    by_cases rev : w.idxOf q < w.idxOf p
    · have := weak q p wq wp rev
      omega
    · by_cases same : w.idxOf p = w.idxOf q
      · have pq : p = q := calc
          p = w[w.idxOf p] := ep.symm
          _ = w[w.idxOf q] := by congr 1
          _ = q := eq
        subst q
        omega
      · omega

private theorem word_packs (L j : Nat) (hL : 5 ≤ L) (_hj : 1 ≤ j) (b : Bool) :
    IsPacking L j (orderWord (L-2 : Nat) b (L+j-2+1)) := by
  refine ⟨word_perm _ _ _, ?_⟩
  intro w hw hend s i t h hi hil hh hhl
  have ei : ((w + i).toNat : Int) = w+i := by omega
  have eh : ((w + h).toNat : Int) = w+h := by omega
  have ip := (mem_positions s (w+i).toNat (L+j-2+1)).mpr (by omega)
  have hp := (mem_positions t (w+h).toNat (L+j-2+1)).mpr (by omega)
  have ord := idx_order (L-2 : Nat) b _ _ _ ip hp
  have window := (realizes_windows (↑(L-2 : Nat)) (↑L) (↑(L+j-2 : Nat))
    (by omega) (by omega) b).2 w hw hend s i t h hi hil hh hhl
  unfold rankIn
  simp only [Int.ofNat_lt]
  apply ord.trans
  simpa only [value, ei, eh] using window

theorem packing_exists {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j) :
    ∃ w, IsPacking L j w := ⟨_, word_packs L j hL hj false⟩

private theorem same_word_on_short {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j) (short : j ≤ L-2)
    {u v : List Position} (hu : IsPacking L j u) (hv : IsPacking L j v) : u = v := by
  let key := value (↑(L-2 : Nat)) false
  have sorted (w : List Position) (hw : IsPacking L j w) :
      w.Pairwise (fun p q => key p < key q) := by
    apply List.pairwise_iff_getElem.mpr
    intro i h hi hh ih
    have distinct := hw.1.nodup_iff.mpr (positions_nodup _)
    have pos (r : Nat) (hr : r < w.length) : w[r].2 ≤ L+j-2 := by
      have mem := hw.1.subset (List.getElem_mem hr)
      exact Nat.le_of_lt_succ ((mem_positions w[r].1 w[r].2 _).mp mem)
    have forced := (uniqueWindowOrder_iff hL hj).mpr short (rankIn w) hw.2
      w[i].1 w[i].2 w[h].1 w[h].2 (pos i hi) (pos h hh)
    apply forced.mp
    simp only [rankIn, Int.toNat_natCast, Int.ofNat_lt]
    change w.idxOf w[i] < w.idxOf w[h]
    rw [distinct.idxOf_getElem, distinct.idxOf_getElem]
    exact ih
  exact List.Perm.eq_of_pairwise (fun _ _ _ _ ab ba => False.elim (Int.lt_asymm ab ba))
    (sorted u hu) (sorted v hv) (hu.1.trans hv.1.symm)

/-- Exactly one finite permutation realizes the prescribed windows precisely up to L−2 copies. -/
theorem unique_permutation_iff {L j : Nat} (hL : 5 ≤ L) (hj : 1 ≤ j) :
    (∃ w, IsPacking L j w ∧ ∀ v, IsPacking L j v → v = w) ↔ j ≤ L-2 := by
  constructor
  · rintro ⟨w, _, unique⟩
    by_cases short : j ≤ L-2
    · exact short
    · exfalso
      let n := L+j-2+1
      let a := L-2
      let p : Position := (.z, 0)
      let q : Position := (.x, 2*a+1)
      have hp : p ∈ positions n := (mem_positions _ _ _).mpr (by dsimp [p,n]; omega)
      have hq : q ∈ positions n := (mem_positions _ _ _).mpr (by dsimp [q,n,a]; omega)
      have e : orderWord a false n = orderWord a true n :=
        (unique _ (word_packs L j hL hj false)).trans (unique _ (word_packs L j hL hj true)).symm
      have first := (idx_order a false n p q hp hq).mpr (by simp [p,q,value,score]; omega)
      have second := (idx_order a true n q p hq hp).mpr (by simp [p,q,value,score]; omega)
      rw [e] at first
      omega
  · intro short
    exact ⟨_, word_packs L j hL hj false, fun _ hv => same_word_on_short hL hj short hv (word_packs _ _ hL hj false)⟩

end Packing.Delay
