# Proof Notes

## Arithmetic

Linear interval arguments use `linarith`; polynomial inequalities use `nlinarith` with explicit nonnegative squares. For `product_le_quarter`, the sole hypothesis `x + y = 1` and `(x-y)² ≥ 0` imply `xy ≤ 1/4`. Nonnegativity of the individual factors is unnecessary. The parameterized bound `x(M-x) ≤ M²/4` holds for all real `x` and `M`.

## Conditional reasoning

`penalty_nonnegative` splits on `0 ≤ x`, the condition used in the definition. The negative branch reduces to a linear inequality; the other branch reduces to a nonnegative square. Threshold mode selection is characterized by an equivalence and an exclusivity theorem.

## Energy safety

`SystemState` records position, velocity, and energy. `Safe` requires nonnegative energy and `velocity² ≤ energy`. The position field is unconstrained. `dampStep` advances position using the old velocity and halves velocity, while retaining energy. `dampRun_preserves_safe` extends one-step preservation by induction.

`dampBy_preserves_safe` permits a signed gain between `-1` and `1`. First, the gain assumptions yield `gain² ≤ 1`. Multiplication by the nonnegative squared velocity preserves this bound, which combines with the initial energy constraint. This permits velocity reversal without increasing the kinetic proxy.

## Dependent types

`IndexedState n` is `Fin n → ℝ`, so operations preserve the number of components in their type. The halving proofs establish componentwise nonnegativity and upper bounds for every valid index. `safeFeedback` goes further: its domain and codomain are subtypes carrying an interval-membership proof. The subtype constructor uses the controller preservation theorem to supply the output proof.

## Coordinate geometry

`Point2` is `ℝ × ℝ`. The geometry results concern squared Euclidean distances and norms, avoiding square roots. Midpoint equidistance follows by polynomial normalization. Pythagoras uses an explicit zero dot-product assumption. The Gram identity

```text
normSq(u) * normSq(v) - dot(u,v)² = (u₁v₂-u₂v₁)²
```

is proved by `ring`; nonnegativity of its right side gives coordinate Cauchy–Schwarz.

## Parameterized capstone

A branch maps `x` to `center + gain * (x-center)`. When both `x` and `center` lie in `[L,U]` and `gain` lies in `[0,1]`, its lower and upper margins can be written as sums of nonnegative products:

```text
output - L = gain * (x-L) + (1-gain) * (center-L)
U - output = gain * (U-x) + (1-gain) * (U-center)
```

`relax_preserves_interval` establishes those product inequalities. `feedbackStep_preserves_interval` reuses the lemma after splitting on the switching condition. Separate targets and gains are allowed in the two branches; the threshold needs no interval assumption.

`scheduledRun_preserves_interval` then proves preservation for any time-varying sequence of transitions satisfying the one-step specification. `feedbackRun_preserves_interval` instantiates the schedule theorem with the parameterized piecewise controller. The fixed controller and its original finite-run theorem remain as concrete examples.

## Foundations

Axiom reports are produced by Lean itself. The verification script accepts only `propext`, `Classical.choice`, and `Quot.sound`, and requires complete audit coverage. This is an explicit foundational dependency policy, not a claim that the proofs avoid all axioms.
