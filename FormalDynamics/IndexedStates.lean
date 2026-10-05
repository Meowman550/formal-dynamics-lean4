import FormalDynamics.BasicLemmas

noncomputable section

namespace FormalDynamics

/-- An n-component real state indexed by `Fin n`. -/
abbrev IndexedState (n : Nat) := Fin n → ℝ

/-- Every component of the indexed state is nonnegative. -/
def ComponentwiseNonnegative {n : Nat} (x : IndexedState n) : Prop :=
  ∀ i, 0 ≤ x i

/-- Scale every component by one half. -/
def halfScale {n : Nat} (x : IndexedState n) : IndexedState n :=
  fun i => x i / 2

/-- The dependent index is preserved and componentwise nonnegativity is invariant. -/
theorem halfScale_preserves_nonnegative {n : Nat} {x : IndexedState n}
    (hx : ComponentwiseNonnegative x) :
    ComponentwiseNonnegative (halfScale x) := by
  intro i
  have hi := hx i
  dsimp [halfScale]
  linarith

/-- Pointwise upper bounds are preserved by halving. -/
theorem halfScale_preserves_upper_bound {n : Nat} {x : IndexedState n} {M : ℝ}
    (hx : ∀ i, x i ≤ M) (hM : 0 ≤ M) :
    ∀ i, halfScale x i ≤ M := by
  intro i
  have hi := hx i
  dsimp [halfScale]
  linarith

end FormalDynamics
