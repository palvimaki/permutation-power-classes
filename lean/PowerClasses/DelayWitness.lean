import Std

namespace Packing.Delay

inductive Track where
  | x | y | z
  deriving DecidableEq

/-- The two orders use integer coordinates for the three tracks. -/
def score (a : Int) (second : Bool) (t : Track) (n : Int) : Int :=
  match t with
  | .x => 3*n
  | .y => 3*(n+a) + (if second then 2 else 1)
  | .z => 3*(n+2*a) + (if second then 4 else 2)

def precedes (a : Int) (second : Bool) (s : Track) (i : Int)
    (t : Track) (h : Int) : Prop :=
  score a second s i < score a second t h

theorem score_eq_iff (a : Int) (second : Bool) (s : Track) (i : Int)
    (t : Track) (h : Int) :
    score a second s i = score a second t h ↔ s = t ∧ i = h := by
  cases second <;> cases s <;> cases t <;> simp [score] <;> omega

theorem shift_score (a w : Int) (second : Bool) (s : Track) (i : Int) :
    score a second s (w+i) = 3*w + score a second s i := by
  cases second <;> cases s <;> simp [score] <;> omega

theorem local_agreement (a l : Int) (ha : a = l - 2) (hl : 5 ≤ l)
    (s : Track) (i : Int) (t : Track) (h : Int)
    (hi : i < h+l) (hh : h < i+l) :
    precedes a true s i t h ↔ precedes a false s i t h := by
  cases s <;> cases t <;> simp [precedes, score] <;> omega

/-- Each window contains exactly l successive triples. The first window defines the pattern. -/
def RealizesWindows (a l last : Int) (f : Track → Int → Int) : Prop :=
  (∀ s i t h, f s i = f t h → s = t ∧ i = h) ∧
  ∀ w : Int, 0 ≤ w → w + l - 1 ≤ last →
    ∀ s i t h, 0 ≤ i → i < l → 0 ≤ h → h < l →
      (f s (w+i) < f t (w+h) ↔ precedes a false s i t h)

theorem realizes_windows (a l last : Int) (ha : a = l-2) (hl : 5 ≤ l)
    (second : Bool) : RealizesWindows a l last (score a second) := by
  constructor
  · intro s i t h
    exact (score_eq_iff a second s i t h).mp
  · intro w _ _ s i t h hi hil hh hhl
    rw [shift_score, shift_score]
    have moved : (3*w + score a second s i < 3*w + score a second t h) ↔
        precedes a second s i t h := by
      unfold precedes
      omega
    apply moved.trans
    cases second with
    | false => exact Iff.rfl
    | true => exact local_agreement a l ha hl s i t h (by omega) (by omega)

/-- Both orders reverse precisely this comparison when the index range reaches it. -/
theorem flipped_pair (a h : Int) :
    precedes a false .z h .x (h+2*a+1) ∧
    precedes a true .x (h+2*a+1) .z h := by
  constructor <;> simp [precedes, score] <;> omega

/-- All parameters are arbitrary. The finite domain consists of triples 0 through last. -/
theorem distinct_window_orders (a l last : Int) (ha : a = l-2) (hl : 5 ≤ l)
    (hsize : 2*a+1 ≤ last) :
    RealizesWindows a l last (score a false) ∧
    RealizesWindows a l last (score a true) ∧
    ∃ s i t h, 0 ≤ i ∧ i ≤ last ∧ 0 ≤ h ∧ h ≤ last ∧
      precedes a false s i t h ∧ precedes a true t h s i := by
  refine ⟨realizes_windows a l last ha hl false, realizes_windows a l last ha hl true, ?_⟩
  refine ⟨.z, 0, .x, 2*a+1, by omega, by omega, by omega, hsize, ?_⟩
  simpa using flipped_pair a 0

end Packing.Delay
