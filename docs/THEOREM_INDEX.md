# Theorem Index

All names are in the `FormalDynamics` namespace.

| Theorem | Module | Main techniques |
|---|---|---|
| `square_nonnegative` | BasicLemmas | `positivity` |
| `rewrite_difference_zero` | BasicLemmas | `rw`, `ring` |
| `translate_interval` | BasicLemmas | `linarith` |
| `scale_upper_bound` | BasicLemmas | `nlinarith` |
| `controlStep_preserves_invariant` | Capstone | `by_cases`, `simp`, `linarith` |
| `run_preserves_invariant` | Capstone | `induction` |
| `three_step_bound` | Capstone | supporting lemmas |
| `relax_preserves_interval` | Capstone | `nlinarith` |
| `feedbackStep_preserves_interval` | Capstone | `by_cases` |
| `scheduledRun_preserves_interval` | Capstone | `induction` |
| `feedbackRun_preserves_interval` | Capstone | supporting lemmas |
| `emergency_iff` | ConditionalLogic | `by_cases`, `simp` |
| `normal_implies_bounded` | ConditionalLogic | `simp` |
| `mode_exclusive` | ConditionalLogic | `rw` |
| `sqDist_nonnegative` | EuclideanGeometry | `nlinarith` |
| `midpoint_equidistant` | EuclideanGeometry | `simp`, `ring` |
| `pythagorean` | EuclideanGeometry | `simp`, `nlinarith` |
| `gram_determinant_identity` | EuclideanGeometry | `ring` |
| `dot_square_le_normSq_product` | EuclideanGeometry | `rw`, `linarith` |
| `halfScale_preserves_nonnegative` | IndexedStates | `linarith` |
| `halfScale_preserves_upper_bound` | IndexedStates | `linarith` |
| `product_le_quarter` | Inequalities | `nlinarith` |
| `quartic_lower_bound` | Inequalities | `nlinarith` |
| `parabola_upper_bound` | Inequalities | `nlinarith` |
| `two_mul_le_square_sum` | Inequalities | `nlinarith` |
| `unit_circle_product_bound` | Inequalities | `nlinarith` |
| `penalty_nonnegative` | PiecewiseFunctions | `by_cases`, `simp`, `linarith` |
| `penalty_eq_square` | PiecewiseFunctions | `simp` |
| `penalty_eq_neg` | PiecewiseFunctions | `simp` |
| `penalty_le_one_of_unit_interval` | PiecewiseFunctions | `rw`, `nlinarith` |
| `affine_bounds` | RealArithmetic | `linarith` |
| `midpoint_between` | RealArithmetic | `linarith` |
| `sum_difference_square_identity` | RealArithmetic | `ring` |
| `symmetric_interval_neg` | RealArithmetic | `linarith` |
| `dampStep_preserves_safe` | StateInvariants | `nlinarith` |
| `dampStep_twice_preserves_safe` | StateInvariants | supporting lemmas |
| `dampBy_preserves_safe` | StateInvariants | `nlinarith` |
| `dampRun_preserves_safe` | StateInvariants | `induction` |

`safeFeedback` is a definition whose output subtype includes an interval-safety proof. It is included in the axiom audit alongside all 38 theorem declarations.
