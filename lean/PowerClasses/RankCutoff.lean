import Std

namespace PowerPackings

/-- Start at the first state in the image of a transfer map. -/
def orbit {α : Type} (f : α → α) (start : α) : Nat → α
  | 0 => start
  | n + 1 => f (orbit f start n)

def PreservesRank {m : Nat} (f : Fin (m + 1) → Fin (m + 1)) : Prop :=
  ∀ a b : Fin (m + 1), a.val ≤ b.val → (f a).val ≤ (f b).val

private theorem propagate {α : Type} (f : α → α) (r : α → α → Prop)
    (map : ∀ a b, r a b → r (f a) (f b)) (start : α)
    (first : r start (f start)) (n : Nat) :
    r (orbit f start n) (f (orbit f start n)) := by
  induction n with
  | zero => exact first
  | succ n ih => exact map _ _ ih

private theorem stabilizeByScore {α : Type} (f : α → α) (start : α)
    (m : Nat) (score : α → Nat) (cap : ∀ a, score a ≤ m)
    (inc : ∀ n, f (orbit f start n) ≠ orbit f start n →
      score (orbit f start n) < score (f (orbit f start n))) :
    f (orbit f start m) = orbit f start m := by
  have progress (n : Nat) :
      n ≤ score (orbit f start n) ∨ f (orbit f start n) = orbit f start n := by
    induction n with
    | zero => exact Or.inl (Nat.zero_le _)
    | succ n ih =>
      by_cases eq : f (orbit f start n) = orbit f start n
      · right
        exact congrArg f eq
      · left
        have old := ih.resolve_right eq
        have step := inc n eq
        change n + 1 ≤ score (f (orbit f start n))
        omega
  by_cases eq : f (orbit f start m) = orbit f start m
  · exact eq
  · have old := (progress m).resolve_right eq
    have step := inc m eq
    have upper := cap (f (orbit f start m))
    omega

/-- Every monotone endomap on a chain of m+1 ranks stops by step m. -/
theorem fixedAtImageBound {m : Nat} (f : Fin (m + 1) → Fin (m + 1))
    (hf : PreservesRank f) (start : Fin (m + 1)) :
    f (orbit f start m) = orbit f start m := by
  by_cases up : start.val ≤ (f start).val
  · apply stabilizeByScore f start m (fun a => a.val)
    · intro a
      have ha := a.isLt
      omega
    · intro n ne
      have h := propagate f (fun a b => a.val ≤ b.val) hf start up n
      have hn : (f (orbit f start n)).val ≠ (orbit f start n).val :=
        fun he => ne (Fin.ext he)
      change (orbit f start n).val ≤ (f (orbit f start n)).val at h
      change (orbit f start n).val < (f (orbit f start n)).val
      omega
  · have down : (f start).val ≤ start.val := by omega
    apply stabilizeByScore f start m (fun a => m - a.val)
    · intro a
      exact Nat.sub_le _ _
    · intro n ne
      have h := propagate f (fun a b => b.val ≤ a.val)
        (fun a b hab => hf b a hab) start down n
      have hn : (f (orbit f start n)).val ≠ (orbit f start n).val :=
        fun he => ne (Fin.ext he)
      have hb := (orbit f start n).isLt
      change (f (orbit f start n)).val ≤ (orbit f start n).val at h
      change m - (orbit f start n).val < m - (f (orbit f start n)).val
      omega

theorem orbitAfterImageBound {m : Nat} (f : Fin (m + 1) → Fin (m + 1))
    (hf : PreservesRank f) (start : Fin (m + 1)) (n : Nat) (hn : m ≤ n) :
    orbit f start n = orbit f start m := by
  have tail (k : Nat) : orbit f start (m + k) = orbit f start m := by
    induction k with
    | zero => rfl
    | succ k ih =>
      change f (orbit f start (m + k)) = orbit f start m
      rw [ih]
      exact fixedAtImageBound f hf start
  have hindex : n = m + (n - m) := by omega
  exact (congrArg (orbit f start) hindex).trans (tail (n - m))

/-- The distance-one states are d₁ and u₁. The two maps may use different
interpretations of the same finite rank chain. The predicate may relate them. -/
theorem transferTestFinite {m : Nat} (hm : 1 ≤ m)
    (d u : Fin (m + 1) → Fin (m + 1)) (hd : PreservesRank d) (hu : PreservesRank u)
    (d₁ u₁ : Fin (m + 1)) (test : Fin (m + 1) → Fin (m + 1) → Prop) :
    (∀ t : Nat, 2 ≤ t → test (orbit d d₁ (t - 1)) (orbit u u₁ (t - 1))) ↔
    (∀ t : Nat, 2 ≤ t → t ≤ m + 1 →
      test (orbit d d₁ (t - 1)) (orbit u u₁ (t - 1))) := by
  constructor
  · intro h t ht _
    exact h t ht
  · intro h t ht
    by_cases hb : t ≤ m + 1
    · exact h t ht hb
    · have after : m ≤ t - 1 := by omega
      rw [orbitAfterImageBound d hd d₁ (t - 1) after,
          orbitAfterImageBound u hu u₁ (t - 1) after]
      have atBound := h (m + 1) (by omega) (by omega)
      have he : m + 1 - 1 = m := by omega
      rw [he] at atBound
      exact atBound

/-- The map on ambient ranks factors through a list of at most m+1 ranks.
The encoding and decoding each preserve order. -/
structure RankTransfer (m : Nat) where
  encode : Nat → Fin (m + 1)
  decode : Fin (m + 1) → Nat
  encode_mono : ∀ x y, x ≤ y → (encode x).val ≤ (encode y).val
  decode_mono : ∀ i j : Fin (m + 1), i.val ≤ j.val → decode i ≤ decode j

namespace RankTransfer

def step {m : Nat} (a : RankTransfer m) (x : Nat) : Nat := a.decode (a.encode x)

def nextIndex {m : Nat} (a : RankTransfer m) (i : Fin (m + 1)) : Fin (m + 1) :=
  a.encode (a.decode i)

theorem nextIndexMonotone {m : Nat} (a : RankTransfer m) : PreservesRank a.nextIndex :=
  fun i j hij => a.encode_mono _ _ (a.decode_mono i j hij)

theorem actualOrbit {m : Nat} (a : RankTransfer m) (x t : Nat) :
    orbit a.step x (t + 1) = a.decode (orbit a.nextIndex (a.encode x) t) := by
  induction t with
  | zero => rfl
  | succ t ih =>
    change a.step (orbit a.step x (t + 1)) = _
    rw [ih]
    rfl

end RankTransfer

/-- Test the original ambient ranks directly after factoring the two transfers.
The two image alphabets may differ. -/
theorem ambientTransferTestFinite {m : Nat} (hm : 1 ≤ m) (D U : RankTransfer m)
    (x : Nat) (test : Nat → Nat → Prop) :
    (∀ t : Nat, 2 ≤ t → test (orbit D.step x t) (orbit U.step x t)) ↔
    (∀ t : Nat, 2 ≤ t → t ≤ m + 1 → test (orbit D.step x t) (orbit U.step x t)) := by
  constructor
  · intro h t ht _
    exact h t ht
  · intro h
    have dist (A : RankTransfer m) (t : Nat) (ht : 2 ≤ t) :
        orbit A.step x t = A.decode (orbit A.nextIndex (A.encode x) (t - 1)) := by
      have hi : t = (t - 1) + 1 := by omega
      exact (congrArg (orbit A.step x) hi).trans (A.actualOrbit x (t - 1))
    have bounded (t : Nat) (ht : 2 ≤ t) (hm' : t ≤ m + 1) :
        test (D.decode (orbit D.nextIndex (D.encode x) (t - 1)))
          (U.decode (orbit U.nextIndex (U.encode x) (t - 1))) := by
      rw [← dist D t ht, ← dist U t ht]
      exact h t ht hm'
    have allTests := (transferTestFinite hm D.nextIndex U.nextIndex
      D.nextIndexMonotone U.nextIndexMonotone (D.encode x) (U.encode x)
      (fun i j => test (D.decode i) (U.decode j))).mpr bounded
    intro t ht
    rw [dist D t ht, dist U t ht]
    exact allTests t ht

/-- Offset zero counts qᵢ ≤ z. Offset one counts qᵢ < z. -/
def beforeCount (offset z : Nat) : List Nat → Nat
  | [] => 0
  | q :: qs => (if q + offset ≤ z then 1 else 0) + beforeCount offset z qs

private theorem beforeCountBound (o z : Nat) (qs : List Nat) :
    beforeCount o z qs ≤ qs.length := by
  induction qs with
  | nil => exact Nat.le_refl _
  | cons q qs ih =>
    by_cases h : q + o ≤ z <;> simp [beforeCount, h] <;> omega

private theorem beforeCountMono (o x y : Nat) (hxy : x ≤ y) (qs : List Nat) :
    beforeCount o x qs ≤ beforeCount o y qs := by
  induction qs with
  | nil => exact Nat.le_refl _
  | cons q qs ih =>
    by_cases hx : q + o ≤ x <;> by_cases hy : q + o ≤ y <;>
      simp [beforeCount, hx, hy] <;> omega

def gapTransfer (qs : List Nat) (offset : Nat) (readRank : Fin (qs.length + 1) → Nat)
    (sorted : ∀ i j : Fin (qs.length + 1), i.val ≤ j.val → readRank i ≤ readRank j) : RankTransfer qs.length where
  encode z := ⟨beforeCount offset z qs, Nat.lt_succ_of_le (beforeCountBound offset z qs)⟩
  decode := readRank
  encode_mono := fun x y hxy => beforeCountMono offset x y hxy qs
  decode_mono := sorted

/-- Given the increasing suffix ranks qs, read the lower ranks from
[0,p₁,…,pₘ] and the upper ranks from [p₁,…,pₘ,K+1].
For every x and y, testing distances 2 through m+1 suffices. -/
theorem rankGapCutoff (qs : List Nat) (hm : 1 ≤ qs.length)
    (lower upper : Fin (qs.length + 1) → Nat)
    (hl : ∀ i j : Fin (qs.length + 1), i.val ≤ j.val → lower i ≤ lower j)
    (hu : ∀ i j : Fin (qs.length + 1), i.val ≤ j.val → upper i ≤ upper j) (x y : Nat) :
    let D := (gapTransfer qs 0 lower hl).step
    let U := (gapTransfer qs 1 upper hu).step
    (∀ t : Nat, 2 ≤ t → y ≤ orbit D x t ∨ orbit U x t ≤ y) ↔
    (∀ t : Nat, 2 ≤ t → t ≤ qs.length + 1 → y ≤ orbit D x t ∨ orbit U x t ≤ y) :=
  ambientTransferTestFinite hm (gapTransfer qs 0 lower hl) (gapTransfer qs 1 upper hu)
    x (fun d u => y ≤ d ∨ u ≤ y)

end PowerPackings
