import PowerClasses.Transfer

namespace Packing.Span

open PowerClasses.Transfer

/-- An offset has its rank in the pattern. The first physical offset is zero.
    Each overlap entry records the new rank and the old rank of one physical position. -/
def shared (r : Nat → Nat) (d m : Nat) : Shared :=
  (List.range m).map fun b => (r b, r (d+b))

/-- A comparison imposed by a prescribed window. Both endpoints are physical positions. -/
def Local (r : Nat → Nat) (d m last u v : Nat) : Prop :=
  ∃ i a b, i ≤ last ∧ a < d+m ∧ b < d+m ∧
    u = i*d+a ∧ v = i*d+b ∧ r a ≤ r b

/-- The reflexive transitive closure of all comparisons from these actual windows. -/
inductive Reach (r : Nat → Nat) (d m last : Nat) : Nat → Nat → Prop
  | refl (u) : Reach r d m last u u
  | tail {u v w} : Reach r d m last u v → Local r d m last v w → Reach r d m last u w

private theorem reachTrans {r d m last u v w} (p : Reach r d m last u v)
    (q : Reach r d m last v w) : Reach r d m last u w := by
  induction q with
  | refl => exact p
  | tail _ e ih => exact .tail ih e

private theorem pathTrans {g u v w} (p : Path g u v) (q : Path g v w) : Path g u w := by
  induction q with
  | refl => exact p
  | tail _ e ih => exact .tail ih e

private theorem member (r : Nat → Nat) (d m b : Nat) (h : b < m) :
    (r b,r (d+b)) ∈ shared r d m := by
  apply List.mem_map.mpr
  exact ⟨b, List.mem_range.mpr h, rfl⟩

/-- All window copies of one physical position connect by adjacent identifications. -/
private theorem slide (r : Nat → Nat) (d m i a n : Nat) (ha : a < d+m) :
    ∀ b, i*d+a = (i+n)*d+b →
      Path (shared r d m) (i,r a) (i+n,r b) ∧ Path (shared r d m) (i+n,r b) (i,r a) := by
  induction n with
  | zero =>
    intro b e
    simp only [Nat.add_zero] at e ⊢
    have hab : a = b := by omega
    subst b
    exact ⟨.refl _, .refl _⟩
  | succ n ih =>
    intro b e
    have ee : i*d+a = (i+n)*d+(d+b) := by
      have ei : i+(n+1) = (i+n)+1 := by omega
      rw [ei,Nat.succ_mul,Nat.add_assoc] at e
      exact e
    have lo := Nat.mul_le_mul_right d (Nat.le_add_right i n)
    have hb : b < m := by omega
    obtain ⟨forward,backward⟩ := ih (d+b) ee
    have h := member r d m b hb
    exact ⟨.tail forward (.forward (i+n) _ h),
      pathTrans (.tail (.refl _) (.backward (i+n) _ h)) backward⟩

private theorem changeCopy (r : Nat → Nat) (d m i k a b : Nat) (ha : a < d+m)
    (hb : b < d+m) (e : i*d+a = k*d+b) : Path (shared r d m) (i,r a) (k,r b) := by
  by_cases h : i ≤ k
  · have hk : i+(k-i) = k := by omega
    have t := slide r d m i a (k-i) ha b (by simpa only [hk] using e)
    simpa only [hk] using t.1
  · have hi : k+(i-k) = i := by omega
    have t := slide r d m k b (i-k) hb a (by simpa only [hi] using e.symm)
    simpa only [hi] using t.2

private theorem liftReach {r d m last u v} (h : Reach r d m last u v) :
    ∀ i a k b, a < d+m → b < d+m → u = i*d+a → v = k*d+b →
      Path (shared r d m) (i,r a) (k,r b) := by
  induction h with
  | refl =>
    intro i a k b ha hb e f
    exact changeCopy r d m i k a b ha hb (e.symm.trans f)
  | tail _ edge ih =>
    intro i a k b ha hb e f
    obtain ⟨w,c,s,_,hc,hs,ev,ew,hrs⟩ := edge
    have start := ih i a w c ha hc e ev
    exact pathTrans (.tail start (.within w _ _ hrs))
      (changeCopy r d m w k s b hs hb (ew.symm.trans f))

private theorem pickLower (g : Shared) (y z : Nat) (hy : 0 < y) :
    y ≤ lower z g → ∃ a ∈ g, y ≤ a.1 ∧ a.2 ≤ z := by
  induction g with
  | nil => simp [lower]; omega
  | cons a g ih =>
    rcases a with ⟨p,q⟩
    intro h
    by_cases hp : q ≤ z
    · simp only [lower, hp, ite_true] at h
      by_cases hpy : y ≤ p
      · exact ⟨_, List.mem_cons_self, hpy, hp⟩
      · have hg : y ≤ lower z g := by omega
        obtain ⟨a,ha,rest⟩ := ih hg
        exact ⟨a, List.mem_cons_of_mem _ ha, rest⟩
    · simp only [lower, hp, ite_false] at h
      obtain ⟨a,ha,rest⟩ := ih h
      exact ⟨a, List.mem_cons_of_mem _ ha, rest⟩

private theorem pickUpper (g : Shared) (top y z : Nat) (hy : y < top) :
    upper top z g ≤ y → ∃ a ∈ g, a.1 ≤ y ∧ z ≤ a.2 := by
  induction g with
  | nil => simp [upper]; omega
  | cons a g ih =>
    rcases a with ⟨p,q⟩
    intro h
    by_cases hp : z ≤ q
    · simp only [upper, hp, ite_true] at h
      by_cases hpy : p ≤ y
      · exact ⟨_, List.mem_cons_self, hpy, hp⟩
      · have hg : upper top z g ≤ y := by grind
        obtain ⟨a,ha,rest⟩ := ih hg
        exact ⟨a, List.mem_cons_of_mem _ ha, rest⟩
    · simp only [upper, hp, ite_false] at h
      obtain ⟨a,ha,rest⟩ := ih h
      exact ⟨a, List.mem_cons_of_mem _ ha, rest⟩

private theorem windowCmp {r d m last i a b} (hi : i ≤ last) (ha : a < d+m)
    (hb : b < d+m) (e : r a ≤ r b) : Reach r d m last (i*d+a) (i*d+b) :=
  .tail (.refl _) ⟨i,a,b,hi,ha,hb,rfl,rfl,e⟩

private theorem realizeLower {r d m last a} (rpos : ∀ b, b < d+m → 0 < r b) (ha : a < d+m)
    (t : Nat) : ∀ b, t ≤ last → b < d+m →
    r b ≤ boundary (fun z => lower z (shared r d m)) (r a) t →
    Reach r d m last (t*d+b) a := by
  induction t with
  | zero =>
    intro b ht hb bound
    simpa using windowCmp (r := r) ht hb ha bound
  | succ t ih =>
    intro b ht hb bound
    obtain ⟨v,hv,hp,hq⟩ := pickLower _ _ _ (rpos b hb) bound
    obtain ⟨s,sm,rfl⟩ := List.mem_map.mp hv
    have hs := List.mem_range.mp sm
    have o : d+s < d+m := by omega
    have eq : (t+1)*d+s = t*d+(d+s) := by simp [Nat.succ_mul, Nat.add_assoc]
    have next := windowCmp (r := r) ht hb (by omega : s < d+m) hp
    rw [eq] at next
    exact reachTrans next (ih (d+s) (by omega) o hq)

private theorem realizeUpper {r d m last a top} (rbd : ∀ b, b < d+m → r b < top) (ha : a < d+m)
    (t : Nat) : ∀ b, t ≤ last → b < d+m →
    boundary (fun z => upper top z (shared r d m)) (r a) t ≤ r b →
    Reach r d m last a (t*d+b) := by
  induction t with
  | zero =>
    intro b ht hb bound
    simpa using windowCmp (r := r) ht ha hb bound
  | succ t ih =>
    intro b ht hb bound
    obtain ⟨v,hv,hp,hq⟩ := pickUpper _ _ _ _ (rbd b hb) bound
    obtain ⟨s,sm,rfl⟩ := List.mem_map.mp hv
    have hs := List.mem_range.mp sm
    have o : d+s < d+m := by omega
    have eq : (t+1)*d+s = t*d+(d+s) := by simp [Nat.succ_mul, Nat.add_assoc]
    have next := windowCmp (r := r) ht (by omega : s < d+m) hb hp
    rw [eq] at next
    exact reachTrans (ih (d+s) (by omega) o hq) next

/-- Fixed-rank cutoffs detect incomparability in the actual finite packing poset.
    The endpoint positions lie in window zero and window t. Later windows are allowed. -/
theorem physicalIncomparable_iff {r : Nat → Nat} {d m last t a b top : Nat}
    (adm : Admissible (shared r d m))
    (bounded : ∀ n, n < d+m → 0 < r n ∧ r n < top)
    (ha : a < d+m) (hb : b < d+m) (ht : t ≤ last) :
    (¬ Reach r d m last a (t*d+b) ∧ ¬ Reach r d m last (t*d+b) a) ↔
    (boundary (fun z => lower z (shared r d m)) (r a) t < r b ∧
      r b < boundary (fun z => upper top z (shared r d m)) (r a) t) := by
  have gBounds : ∀ v ∈ shared r d m, (0 < v.1 ∧ 0 < v.2) ∧ (v.1 < top ∧ v.2 < top) := by
    intro v hv
    obtain ⟨s,sm,rfl⟩ := List.mem_map.mp hv
    have hs := List.mem_range.mp sm
    obtain ⟨a1,a2⟩ := bounded s (by omega)
    obtain ⟨b1,b2⟩ := bounded (d+s) (by omega)
    exact ⟨⟨a1,b1⟩,a2,b2⟩
  have betweenLower : Reach r d m last (t*d+b) a ↔
      r b ≤ boundary (fun z => lower z (shared r d m)) (r a) t := by
    constructor
    · intro h
      exact (path_to_start_iff adm (fun v hv => (gBounds v hv).1) _ _ _ (bounded b hb).1).mp
        (liftReach h t b 0 a hb ha rfl (by simp))
    · exact realizeLower (fun n hn => (bounded n hn).1) ha t b ht hb
  have betweenUpper : Reach r d m last a (t*d+b) ↔
      boundary (fun z => upper top z (shared r d m)) (r a) t ≤ r b := by
    constructor
    · intro h
      exact (path_from_start_iff adm top (fun v hv => (gBounds v hv).2) _ _ _ (bounded b hb).2).mp
        (liftReach h 0 a t b ha hb (by simp) rfl)
    · exact realizeUpper (fun n hn => (bounded n hn).2) ha t b ht hb
  constructor
  · rintro ⟨nf, nb⟩
    exact ⟨Nat.lt_of_not_ge (fun e => nb (betweenLower.mpr e)),
      Nat.lt_of_not_ge (fun e => nf (betweenUpper.mpr e))⟩
  · rintro ⟨lo, up⟩
    exact ⟨fun h => (Nat.not_le.mpr up) (betweenUpper.mp h),
      fun h => (Nat.not_le.mpr lo) (betweenLower.mp h)⟩

end Packing.Span

#print axioms Packing.Span.physicalIncomparable_iff

namespace Packing.Span

open PowerClasses.Transfer

private def countBelow (z : Nat) : List Nat → Nat
  | [] => 0
  | a :: l => (if a ≤ z then 1 else 0) + countBelow z l

private theorem countBound (z : Nat) (l : List Nat) : countBelow z l ≤ l.length := by
  induction l with
  | nil => exact Nat.zero_le _
  | cons a l ih => by_cases e : a ≤ z <;> simp [countBelow, e] <;> omega

private theorem countMono {x y : Nat} (h : x ≤ y) (l : List Nat) : countBelow x l ≤ countBelow y l := by
  induction l with
  | nil => exact Nat.zero_le _
  | cons a l ih =>
    by_cases e : a ≤ x <;> by_cases f : a ≤ y <;> simp [countBelow, e, f] <;> omega

private theorem countStrict {x y : Nat} (h : x < y) (l : List Nat) (mem : y ∈ l) :
    countBelow x l < countBelow y l := by
  induction l with
  | nil => simp at mem
  | cons a l ih =>
    rcases List.mem_cons.mp mem with e | mem
    · subst a
      have hm := countMono (Nat.le_of_lt h) l
      simp [countBelow, Nat.not_le.mpr h]
      omega
    · have hm := ih mem
      by_cases e : a ≤ x <;> by_cases f : a ≤ y <;> simp [countBelow, e, f] <;> omega

private theorem countPositive {x : Nat} (l : List Nat) (mem : x ∈ l) : 0 < countBelow x l := by
  induction l with
  | nil => simp at mem
  | cons a l ih =>
    rcases List.mem_cons.mp mem with e | mem
    · subst a
      simp [countBelow] <;> omega
    · have hm := ih mem
      by_cases e : a ≤ x <;> simp [countBelow, e] <;> omega

private theorem fixedFromProgress (f : Nat → Nat) (start m : Nat) (score : Nat → Nat)
    (cap : ∀ n, score (boundary f start n) ≤ m)
    (inc : ∀ n, f (boundary f start n) ≠ boundary f start n →
      score (boundary f start n) < score (f (boundary f start n))) :
    f (boundary f start m) = boundary f start m := by
  have loop (n : Nat) : n ≤ score (boundary f start n) ∨ f (boundary f start n) = boundary f start n := by
    induction n with
    | zero => exact Or.inl (Nat.zero_le _)
    | succ n ih =>
      by_cases e : f (boundary f start n) = boundary f start n
      · exact Or.inr (congrArg f e)
      · have h := ih.resolve_right e
        have s := inc n e
        left
        change n+1 ≤ score (f (boundary f start n))
        omega
  by_cases e : f (boundary f start m) = boundary f start m
  · exact e
  · have h := (loop m).resolve_right e
    have step := inc m e
    have maxScore := cap (m+1)
    change score (f (boundary f start m)) ≤ m at maxScore
    omega

private theorem boundaryShift (f : Nat → Nat) (x t : Nat) :
    boundary f x (t+1) = boundary f (f x) t := by
  induction t with
  | zero => rfl
  | succ t ih => exact congrArg f ih

/-- Stabilization for an increasing self-map with an explicitly listed finite image. -/
private theorem stableImage (f : Nat → Nat) (mono : ∀ {x y}, x ≤ y → f x ≤ f y)
    (l : List Nat) (inList : ∀ x, f x ∈ l) (m : Nat) (hl : l.length = m+1)
    (x t : Nat) (ht : m+1 ≤ t) :
    boundary f x t = boundary f x (m+1) := by
  let start := f x
  have mem (n : Nat) : boundary f start n ∈ l := by
    cases n with
    | zero => exact inList x
    | succ n => exact inList _
  have fixed : f (boundary f start m) = boundary f start m := by
    by_cases h : start ≤ f start
    · have up (n : Nat) : boundary f start n ≤ f (boundary f start n) := by
        induction n with
        | zero => exact h
        | succ n ih => exact mono ih
      apply fixedFromProgress f start m (fun v => countBelow v l - 1)
      · intro n
        have c := countBound (boundary f start n) l
        omega
      · intro n ne
        have old := up n
        have positive := countPositive l (mem n)
        have strict := countStrict (Nat.lt_of_le_of_ne old (Ne.symm ne)) l (inList _)
        omega
    · have down (n : Nat) : f (boundary f start n) ≤ boundary f start n := by
        induction n with
        | zero => exact Nat.le_of_lt (Nat.lt_of_not_ge h)
        | succ n ih => exact mono ih
      apply fixedFromProgress f start m (fun v => l.length - countBelow v l)
      · intro n
        have c := countPositive l (mem n)
        omega
      · intro n ne
        have old := down n
        have cap := countBound (boundary f start n) l
        have strict := countStrict (Nat.lt_of_le_of_ne old ne) l (mem n)
        omega
  have tail (n : Nat) : boundary f start (m+n) = boundary f start m := by
    induction n with
    | zero => rfl
    | succ n ih =>
      change f (boundary f start (m+n)) = _
      rw [ih, fixed]
  have e : t = (m+(t-(m+1)))+1 := by omega
  rw [e, boundaryShift, boundaryShift]
  exact tail _

private theorem lowerMono (g : Shared) {x y : Nat} (h : x ≤ y) : lower x g ≤ lower y g := by
  induction g with
  | nil => exact Nat.le_refl _
  | cons a g ih =>
    rcases a with ⟨p,q⟩
    by_cases e : q ≤ x <;> by_cases f : q ≤ y <;> simp only [lower, e, f, ite_true, ite_false] <;> grind

private theorem upperMono (g : Shared) (top : Nat) {x y : Nat} (h : x ≤ y) :
    upper top x g ≤ upper top y g := by
  induction g with
  | nil => exact Nat.le_refl _
  | cons a g ih =>
    rcases a with ⟨p,q⟩
    by_cases e : x ≤ q <;> by_cases f : y ≤ q <;> simp only [upper, e, f, ite_true, ite_false] <;> grind

private theorem lowerImage (g : Shared) (z : Nat) : lower z g ∈ 0 :: g.map Prod.fst := by
  induction g with
  | nil => simp [lower]
  | cons a g ih =>
    rcases a with ⟨p,q⟩
    simp only [List.map_cons, List.mem_cons] at ih ⊢
    by_cases e : q ≤ z
    · simp only [lower, e, ite_true]
      by_cases k : p ≤ lower z g
      · rw [Nat.max_eq_right k]
        grind
      · rw [Nat.max_eq_left (Nat.le_of_lt (Nat.lt_of_not_ge k))]
        simp
    · simp only [lower, e, ite_false]
      grind

private theorem upperImage (g : Shared) (top z : Nat) : upper top z g ∈ top :: g.map Prod.fst := by
  induction g with
  | nil => simp [upper]
  | cons a g ih =>
    rcases a with ⟨p,q⟩
    simp only [List.map_cons, List.mem_cons] at ih ⊢
    by_cases e : z ≤ q
    · simp only [upper, e, ite_true]
      by_cases k : p ≤ upper top z g
      · rw [Nat.min_eq_left k]
        simp
      · rw [Nat.min_eq_right (Nat.le_of_lt (Nat.lt_of_not_ge k))]
        grind
    · simp only [upper, e, ite_false]
      grind

/-- An endpoint witness in any strip. The first position leaves after window i.
    The second position enters in window i+t. These offset conditions give distance t for t > 0. -/
def Witness (r : Nat → Nat) (d m t : Nat) : Prop :=
  ∃ last i a b, i+t ≤ last ∧ a < d ∧ m ≤ b ∧ b < d+m ∧
    ¬ Reach r d m last (i*d+a) ((i+t)*d+b) ∧
    ¬ Reach r d m last ((i+t)*d+b) (i*d+a)

private theorem translateReach {r d m last u v} (p : Reach r d m last u v)
    (i total : Nat) (fit : i+last ≤ total) : Reach r d m total (i*d+u) (i*d+v) := by
  induction p with
  | refl => exact .refl _
  | tail _ edge ih =>
    obtain ⟨w,a,b,hw,ha,hb,rfl,rfl,h⟩ := edge
    apply Reach.tail ih
    exact ⟨i+w,a,b,by omega,ha,hb,by simp [Nat.add_mul,Nat.add_assoc],
      by simp [Nat.add_mul,Nat.add_assoc],h⟩

private theorem witnessGap {r d m t top}
    (adm : Admissible (shared r d m)) (bounded : ∀ n, n < d+m → 0 < r n ∧ r n < top) :
    Witness r d m t ↔ ∃ a b, a < d ∧ m ≤ b ∧ b < d+m ∧
      boundary (fun z => lower z (shared r d m)) (r a) t < r b ∧
      r b < boundary (fun z => upper top z (shared r d m)) (r a) t := by
  constructor
  · rintro ⟨last,i,a,b,fit,ha,hm,hb,nf,nb⟩
    refine ⟨a,b,ha,hm,hb,?_⟩
    apply (physicalIncomparable_iff adm bounded (by omega : a < d+m) hb (Nat.le_refl t)).mp
    constructor
    · intro path
      apply nf
      simpa [Nat.add_mul,Nat.add_assoc] using translateReach path i last fit
    · intro path
      apply nb
      simpa [Nat.add_mul,Nat.add_assoc] using translateReach path i last fit
  · rintro ⟨a,b,ha,hm,hb,low,up⟩
    obtain ⟨nf,nb⟩ := (physicalIncomparable_iff adm bounded (by omega : a < d+m) hb (Nat.le_refl t)).mpr ⟨low,up⟩
    exact ⟨t,0,a,b,by omega,ha,hm,hb,by simpa using nf,by simpa using nb⟩

/-- At every distance at least m+1, the existence of a physical incomparable pair
    equals the answer at m+1. This includes strips with extra windows on either side. -/
theorem tailWitness_iff {r d m t top} (adm : Admissible (shared r d m))
    (bounded : ∀ n, n < d+m → 0 < r n ∧ r n < top) (ht : m+1 ≤ t) :
    Witness r d m t ↔ Witness r d m (m+1) := by
  let g := shared r d m
  have len (s : Nat) : (s :: g.map Prod.fst).length = m+1 := by simp [g,shared]
  have dl (x : Nat) := stableImage (fun z => lower z g) (fun h => lowerMono g h)
    _ (lowerImage g) m (len 0) x t ht
  have ul (x : Nat) := stableImage (fun z => upper top z g) (fun h => upperMono g top h)
    _ (upperImage g top) m (len top) x t ht
  rw [witnessGap adm bounded, witnessGap adm bounded]
  constructor <;> rintro ⟨a,b,ha,hm,hb,lo,up⟩ <;> refine ⟨a,b,ha,hm,hb,?_,?_⟩
  · exact (dl (r a)) ▸ (show boundary (fun z => lower z g) (r a) t < r b from lo)
  · exact (ul (r a)) ▸ (show r b < boundary (fun z => upper top z g) (r a) t from up)
  · exact (dl (r a)).symm ▸ (show boundary (fun z => lower z g) (r a) (m+1) < r b from lo)
  · exact (ul (r a)).symm ▸ (show r b < boundary (fun z => upper top z g) (r a) (m+1) from up)

theorem unboundedWitness_iff {r d m top} (adm : Admissible (shared r d m))
    (bounded : ∀ n, n < d+m → 0 < r n ∧ r n < top) :
    (∀ n, ∃ t, n ≤ t ∧ Witness r d m t) ↔ Witness r d m (m+1) := by
  constructor
  · intro h
    obtain ⟨t,ht,w⟩ := h (m+1)
    exact (tailWitness_iff adm bounded ht).mp w
  · intro h n
    exact ⟨max n (m+1),Nat.le_max_left _ _,
      (tailWitness_iff adm bounded (Nat.le_max_right _ _)).mpr h⟩

end Packing.Span

#print axioms Packing.Span.tailWitness_iff
#print axioms Packing.Span.unboundedWitness_iff

namespace Packing.Span

/-- A one-line permutation is an injective rank assignment on a finite set of the same size. -/
structure Pattern (K : Nat) where
  atPos : Fin K → Fin K
  injective : ∀ i j, atPos i = atPos j → i = j

def Pattern.rank {K} (p : Pattern K) (n : Nat) : Nat :=
  if h : n < K then (p.atPos ⟨n,h⟩).val+1 else 0

private theorem patternBounds {K} (p : Pattern K) (n : Nat) (h : n < K) :
    0 < p.rank n ∧ p.rank n < K+1 := by
  simp only [Pattern.rank, dite_eq_left h]
  have := (p.atPos ⟨n,h⟩).isLt
  omega

def Contains (d m i u : Nat) : Prop := i*d ≤ u ∧ u < i*d+(d+m)

/-- The support of u ends at i. The support of v starts at i+t in this finite strip. -/
def DistanceWitness (r : Nat → Nat) (d m t : Nat) : Prop :=
  ∃ last i u v, i+t ≤ last ∧ Contains d m i u ∧ Contains d m (i+t) v ∧
    (∀ w, w ≤ last → Contains d m w u → w ≤ i) ∧
    (∀ w, w ≤ last → Contains d m w v → i+t ≤ w) ∧
    ¬ Reach r d m last u v ∧ ¬ Reach r d m last v u

private theorem byOffsets {r d m t} (ht : 0 < t) :
    DistanceWitness r d m t ↔ Witness r d m t := by
  cases t with
  | zero => omega
  | succ t =>
    constructor
    · rintro ⟨last,i,u,v,within,⟨ush,uf⟩,⟨vs,vf⟩,left,right,hx,hy⟩
      let a := u-i*d
      let b := v-(i+(t+1))*d
      have ua : u = i*d+a := by dsimp [a]; omega
      have vb : v = (i+(t+1))*d+b := by dsimp [b]; omega
      have iq : i+(t+1) = (i+t)+1 := by omega
      have strideEq : (i+(t+1))*d = (i+t)*d+d := by rw [iq, Nat.succ_mul]
      have ha : a < d := by
        apply Classical.byContradiction
        intro bad
        have mem : Contains d m (i+1) u := by
          unfold Contains
          rw [Nat.succ_mul]
          omega
        have := left (i+1) (by omega) mem
        omega
      have hm : m ≤ b := by
        apply Classical.byContradiction
        intro bad
        have mem : Contains d m (i+t) v := by
          unfold Contains
          omega
        have := right (i+t) (by omega) mem
        omega
      exact ⟨last,i,a,b,within,ha,hm,by omega,ua ▸ vb ▸ hx,ua ▸ vb ▸ hy⟩
    · rintro ⟨last,i,a,b,within,ha,hm,hb,hx,hy⟩
      refine ⟨last,i,i*d+a,(i+(t+1))*d+b,within,⟨by omega,by omega⟩,⟨by omega,by omega⟩,?_,?_,hx,hy⟩
      · intro w _ member
        have bound := member.1
        by_cases h : w ≤ i
        · exact h
        · have cmp := Nat.mul_le_mul_right d (by omega : i+1 ≤ w)
          rw [Nat.succ_mul] at cmp
          omega
      · intro w _ member
        have bound := member.2
        by_cases h : i+(t+1) ≤ w
        · exact h
        · have cmp := Nat.mul_le_mul_right d (by omega : w+1 ≤ i+(t+1))
          rw [Nat.succ_mul] at cmp
          omega

/-- The classifier for actual permutations and the literal support-interval distance. -/
theorem permutationSpan_iff {d m} (p : Pattern (d+m))
    (adm : PowerClasses.Transfer.Admissible (shared p.rank d m)) :
    (∀ n, ∃ t, n ≤ t ∧ DistanceWitness p.rank d m t) ↔
    ∃ a b, a < d ∧ m ≤ b ∧ b < d+m ∧
      PowerClasses.Transfer.boundary (fun z => PowerClasses.Transfer.lower z (shared p.rank d m))
        (p.rank a) (m+1) < p.rank b ∧
      p.rank b < PowerClasses.Transfer.boundary
        (fun z => PowerClasses.Transfer.upper (d+m+1) z (shared p.rank d m)) (p.rank a) (m+1) := by
  rw [← witnessGap adm (patternBounds p), ← unboundedWitness_iff adm (patternBounds p)]
  constructor
  · intro h n
    obtain ⟨t,ht,hw⟩ := h (max n 1)
    exact ⟨t,by omega,(byOffsets (by omega)).mp hw⟩
  · intro h n
    obtain ⟨t,ht,hw⟩ := h (max n 1)
    exact ⟨t,by omega,(byOffsets (by omega)).mpr hw⟩

theorem permutationTail_iff {d m t} (p : Pattern (d+m))
    (adm : PowerClasses.Transfer.Admissible (shared p.rank d m)) (ht : m+1 ≤ t) :
    DistanceWitness p.rank d m t ↔ DistanceWitness p.rank d m (m+1) := by
  rw [byOffsets (by omega : 0 < t), byOffsets (by omega : 0 < m+1)]
  exact tailWitness_iff adm (patternBounds p) ht

end Packing.Span

#print axioms Packing.Span.permutationSpan_iff
#print axioms Packing.Span.permutationTail_iff

namespace Packing.Span

open PowerClasses.Transfer

/-- The executable classifier tests finitely many pairs of offsets at distance m+1. -/
def infiniteSpan? {d m} (p : Pattern (d+m)) : Bool :=
  let g := shared p.rank d m
  (List.range d).any fun a => (List.range (d+m)).any fun b =>
    decide (m ≤ b ∧ boundary (fun z => lower z g) (p.rank a) (m+1) < p.rank b ∧
      p.rank b < boundary (fun z => upper (d+m+1) z g) (p.rank a) (m+1))

theorem infiniteSpan_correct {d m} (p : Pattern (d+m)) (adm : Admissible (shared p.rank d m)) :
    infiniteSpan? p = true ↔ ∀ n, ∃ t, n ≤ t ∧ DistanceWitness p.rank d m t := by
  rw [permutationSpan_iff p adm]
  simp only [infiniteSpan?, List.any_eq_true, List.mem_range, decide_eq_true_eq]
  constructor
  · rintro ⟨a,ha,b,hb,hm,lo,up⟩
    exact ⟨a,b,ha,hm,hb,lo,up⟩
  · rintro ⟨a,b,ha,hm,hb,lo,up⟩
    exact ⟨a,ha,b,hb,hm,lo,up⟩

end Packing.Span

#print axioms Packing.Span.infiniteSpan_correct

namespace Packing.Span

open PowerClasses.Transfer

/-- The same rank test determines each positive distance separately. -/
theorem permutationDistance_iff {d m t} (p : Pattern (d+m)) (adm : Admissible (shared p.rank d m))
    (ht : 0 < t) :
    DistanceWitness p.rank d m t ↔ ∃ a b, a < d ∧ m ≤ b ∧ b < d+m ∧
      boundary (fun z => lower z (shared p.rank d m)) (p.rank a) t < p.rank b ∧
      p.rank b < boundary (fun z => upper (d+m+1) z (shared p.rank d m)) (p.rank a) t :=
  (byOffsets ht).trans (witnessGap adm (patternBounds p))

end Packing.Span

#print axioms Packing.Span.permutationDistance_iff
