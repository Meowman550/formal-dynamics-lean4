import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Positivity

namespace FormalDynamics

/-- Every real square is nonnegative. -/
theorem square_nonnegative (x : ℝ) : 0 ≤ x ^ 2 := by
  positivity

/-- Equality permits cancellation of a real difference. -/
theorem rewrite_difference_zero {x y : ℝ} (h : x = y) : x - y = 0 := by
  rw [h]
  ring

/-- Translating both endpoints of an interval preserves membership. -/
theorem translate_interval {a b x c : ℝ}
    (hax : a ≤ x) (hxb : x ≤ b) :
    a + c ≤ x + c ∧ x + c ≤ b + c := by
  constructor <;> linarith

/-- Multiplication by a nonnegative scalar preserves an upper bound. -/
theorem scale_upper_bound {x y k : ℝ}
    (hxy : x ≤ y) (hk : 0 ≤ k) : k * x ≤ k * y := by
  nlinarith

end FormalDynamics
