import FormalDynamics.BasicLemmas

noncomputable section

namespace FormalDynamics

abbrev Point2 := ℝ × ℝ

/-- Squared Euclidean distance in the plane. -/
def sqDist (p q : Point2) : ℝ :=
  (p.1 - q.1) ^ 2 + (p.2 - q.2) ^ 2

/-- Coordinate midpoint of two planar points. -/
def midpoint (p q : Point2) : Point2 :=
  ((p.1 + q.1) / 2, (p.2 + q.2) / 2)

/-- Squared Euclidean distance is nonnegative. -/
theorem sqDist_nonnegative (p q : Point2) : 0 ≤ sqDist p q := by
  dsimp [sqDist]
  nlinarith [sq_nonneg (p.1 - q.1), sq_nonneg (p.2 - q.2)]

/-- The midpoint is equidistant from the two endpoints. -/
theorem midpoint_equidistant (p q : Point2) :
    sqDist (midpoint p q) p = sqDist (midpoint p q) q := by
  rcases p with ⟨px, py⟩
  rcases q with ⟨qx, qy⟩
  simp [sqDist, midpoint]
  ring

/-- Standard coordinate dot product. -/
def dot (u v : Point2) : ℝ := u.1 * v.1 + u.2 * v.2

/-- Squared Euclidean norm. -/
def normSq (u : Point2) : ℝ := u.1 ^ 2 + u.2 ^ 2

/-- Orthogonality yields the Pythagorean identity. -/
theorem pythagorean {u v : Point2} (horth : dot u v = 0) :
    normSq (u.1 + v.1, u.2 + v.2) = normSq u + normSq v := by
  rcases u with ⟨ux, uy⟩
  rcases v with ⟨vx, vy⟩
  simp [dot, normSq] at horth ⊢
  nlinarith

/-- The planar Gram determinant is a square of the oriented area. -/
theorem gram_determinant_identity (u v : Point2) :
    normSq u * normSq v - dot u v ^ 2 =
      (u.1 * v.2 - u.2 * v.1) ^ 2 := by
  dsimp [normSq, dot]
  ring

/-- Coordinate Cauchy–Schwarz follows from the nonnegative Gram determinant. -/
theorem dot_square_le_normSq_product (u v : Point2) :
    dot u v ^ 2 ≤ normSq u * normSq v := by
  have h := sq_nonneg (u.1 * v.2 - u.2 * v.1)
  rw [← gram_determinant_identity] at h
  linarith

end FormalDynamics
