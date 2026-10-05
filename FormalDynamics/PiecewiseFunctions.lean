import FormalDynamics.BasicLemmas

noncomputable section

namespace FormalDynamics

/-- A simple piecewise real-valued penalty function. -/
def penalty (x : ℝ) : ℝ :=
  if 0 ≤ x then x ^ 2 else -x

/-- The penalty function is nonnegative on all real inputs. -/
theorem penalty_nonnegative (x : ℝ) : 0 ≤ penalty x := by
  by_cases h : 0 ≤ x
  · simp [penalty, h]
  · have hx : x < 0 := lt_of_not_ge h
    have hneg : 0 ≤ -x := by linarith
    simpa [penalty, h] using hneg

/-- On nonnegative inputs the quadratic branch is selected. -/
theorem penalty_eq_square {x : ℝ} (h : 0 ≤ x) : penalty x = x ^ 2 := by
  simp [penalty, h]

/-- On negative inputs the linear branch is selected. -/
theorem penalty_eq_neg {x : ℝ} (h : x < 0) : penalty x = -x := by
  have hn : ¬ 0 ≤ x := not_le.mpr h
  simp [penalty, hn]

/-- A branch-local upper bound for the nonnegative side. -/
theorem penalty_le_one_of_unit_interval {x : ℝ}
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) : penalty x ≤ 1 := by
  rw [penalty_eq_square hx0]
  nlinarith [sq_nonneg x]

end FormalDynamics
