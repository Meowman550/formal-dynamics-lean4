import FormalDynamics.BasicLemmas

namespace FormalDynamics

/-- The product is bounded by one quarter whenever two reals sum to one. -/
theorem product_le_quarter {x y : ℝ}
    (hsum : x + y = 1) :
    x * y ≤ (1 : ℝ) / 4 := by
  nlinarith [sq_nonneg (x - y)]

/-- A quartic inequality obtained from a square. -/
theorem quartic_lower_bound (x : ℝ) :
    2 * x ^ 2 ≤ x ^ 4 + 1 := by
  nlinarith [sq_nonneg (x ^ 2 - 1)]

/-- The concave quadratic x(M-x) never exceeds M²/4. -/
theorem parabola_upper_bound (x M : ℝ) :
    x * (M - x) ≤ M ^ 2 / 4 := by
  nlinarith [sq_nonneg (2 * x - M)]

/-- Twice a product is at most the sum of the two squares. -/
theorem two_mul_le_square_sum (x y : ℝ) :
    2 * x * y ≤ x ^ 2 + y ^ 2 := by
  nlinarith [sq_nonneg (x - y)]

/-- Unit-circle coordinates satisfy the standard product bound. -/
theorem unit_circle_product_bound {x y : ℝ}
    (hcircle : x ^ 2 + y ^ 2 = 1) :
    2 * x * y ≤ 1 := by
  nlinarith [sq_nonneg (x - y)]

end FormalDynamics
