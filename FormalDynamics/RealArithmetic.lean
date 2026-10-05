import FormalDynamics.BasicLemmas

namespace FormalDynamics

/-- An affine map with positive slope preserves interval bounds. -/
theorem affine_bounds {a b x : ℝ}
    (hax : a ≤ x) (hxb : x ≤ b) :
    2 * a + 3 ≤ 2 * x + 3 ∧ 2 * x + 3 ≤ 2 * b + 3 := by
  constructor <;> linarith

/-- The midpoint of two ordered reals lies between them. -/
theorem midpoint_between {a b : ℝ} (hab : a ≤ b) :
    a ≤ (a + b) / 2 ∧ (a + b) / 2 ≤ b := by
  constructor <;> linarith

/-- A standard quadratic identity over the reals. -/
theorem sum_difference_square_identity (x y : ℝ) :
    (x + y) ^ 2 + (x - y) ^ 2 = 2 * x ^ 2 + 2 * y ^ 2 := by
  ring

/-- A symmetric real interval is closed under negation. -/
theorem symmetric_interval_neg {M x : ℝ}
    (hx : -M ≤ x ∧ x ≤ M) :
    -M ≤ -x ∧ -x ≤ M := by
  rcases hx with ⟨hl, hu⟩
  constructor <;> linarith

end FormalDynamics
