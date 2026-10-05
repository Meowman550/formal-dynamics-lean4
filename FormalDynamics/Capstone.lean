import FormalDynamics.BasicLemmas

noncomputable section

namespace FormalDynamics

/-- The safe operating interval for the scalar closed-loop system. -/
def Invariant (x : ℝ) : Prop := -1 ≤ x ∧ x ≤ 1

/--
A piecewise feedback transition. Nonpositive states relax toward `1` with
gain `1/2`; positive states relax toward `0` with gain `1/2`.
-/
def controlStep (x : ℝ) : ℝ :=
  if x ≤ 0 then (x + 1) / 2 else x / 2

/-- The closed-loop transition preserves the interval invariant. -/
theorem controlStep_preserves_invariant {x : ℝ} (hx : Invariant x) :
    Invariant (controlStep x) := by
  rcases hx with ⟨hlower, hupper⟩
  change -1 ≤ controlStep x ∧ controlStep x ≤ 1
  by_cases h : x ≤ 0
  · constructor
    · simp [controlStep, h]
      linarith
    · simp [controlStep, h]
      linarith
  · have hpos : 0 < x := lt_of_not_ge h
    constructor
    · simp [controlStep, h]
      linarith
    · simp [controlStep, h]
      linarith

/-- Execute the controller for a finite number of steps. -/
def run : Nat → ℝ → ℝ
  | 0, x => x
  | n + 1, x => run n (controlStep x)

/-- The invariant is preserved for any finite execution length. -/
theorem run_preserves_invariant (n : Nat) {x : ℝ} (hx : Invariant x) :
    Invariant (run n x) := by
  induction n generalizing x with
  | zero =>
      simpa [run] using hx
  | succ n ih =>
      change Invariant (run n (controlStep x))
      exact ih (controlStep_preserves_invariant hx)

/-- A state starting in the invariant interval remains bounded after three steps. -/
theorem three_step_bound {x : ℝ} (hx : Invariant x) :
    -1 ≤ run 3 x ∧ run 3 x ≤ 1 := by
  simpa [Invariant] using run_preserves_invariant 3 hx

/-- Relaxation toward any point in the interval preserves both bounds. -/
theorem relax_preserves_interval {L U center gain x : ℝ}
    (hc : L ≤ center ∧ center ≤ U) (hg : 0 ≤ gain ∧ gain ≤ 1)
    (hx : L ≤ x ∧ x ≤ U) :
    L ≤ center + gain * (x - center) ∧
      center + gain * (x - center) ≤ U := by
  have hlo := mul_nonneg hg.1 (sub_nonneg.mpr hx.1)
  have hhi := mul_nonneg hg.1 (sub_nonneg.mpr hx.2)
  have hclo := mul_nonneg (sub_nonneg.mpr hg.2) (sub_nonneg.mpr hc.1)
  have hchi := mul_nonneg (sub_nonneg.mpr hg.2) (sub_nonneg.mpr hc.2)
  constructor <;> nlinarith

/-- Each branch relaxes toward a separately chosen target. -/
def feedbackStep (threshold lowerTarget upperTarget lowerGain upperGain x : ℝ) : ℝ :=
  if x ≤ threshold then lowerTarget + lowerGain * (x - lowerTarget)
  else upperTarget + upperGain * (x - upperTarget)

/-- The switching threshold is arbitrary; both branch targets must be safe. -/
theorem feedbackStep_preserves_interval {L U threshold lowerTarget upperTarget
    lowerGain upperGain x : ℝ}
    (hl : L ≤ lowerTarget ∧ lowerTarget ≤ U)
    (hu : L ≤ upperTarget ∧ upperTarget ≤ U)
    (hgl : 0 ≤ lowerGain ∧ lowerGain ≤ 1)
    (hgu : 0 ≤ upperGain ∧ upperGain ≤ 1)
    (hx : L ≤ x ∧ x ≤ U) :
    L ≤ feedbackStep threshold lowerTarget upperTarget lowerGain upperGain x ∧
      feedbackStep threshold lowerTarget upperTarget lowerGain upperGain x ≤ U := by
  by_cases h : x ≤ threshold
  · simpa [feedbackStep, h] using relax_preserves_interval hl hgl hx
  · simpa [feedbackStep, h] using relax_preserves_interval hu hgu hx

/-- Finite execution with a controller schedule that may change at every step. -/
def scheduledRun (transition : Nat → ℝ → ℝ) : Nat → ℝ → ℝ
  | 0, x => x
  | n + 1, x => transition n (scheduledRun transition n x)

/-- Arbitrary time-varying transitions preserve the interval if every step does. -/
theorem scheduledRun_preserves_interval {L U : ℝ} (transition : Nat → ℝ → ℝ)
    (hstep : ∀ n x, L ≤ x ∧ x ≤ U →
      L ≤ transition n x ∧ transition n x ≤ U)
    (n : Nat) {x : ℝ} (hx : L ≤ x ∧ x ≤ U) :
    L ≤ scheduledRun transition n x ∧ scheduledRun transition n x ≤ U := by
  induction n with
  | zero => simpa [scheduledRun] using hx
  | succ n ih => exact hstep n _ ih

/-- Every finite execution of the parameterized controller stays in its interval. -/
theorem feedbackRun_preserves_interval {L U threshold lowerTarget upperTarget
    lowerGain upperGain x : ℝ}
    (hl : L ≤ lowerTarget ∧ lowerTarget ≤ U)
    (hu : L ≤ upperTarget ∧ upperTarget ≤ U)
    (hgl : 0 ≤ lowerGain ∧ lowerGain ≤ 1)
    (hgu : 0 ≤ upperGain ∧ upperGain ≤ 1)
    (n : Nat) (hx : L ≤ x ∧ x ≤ U) :
    let output := scheduledRun
      (fun _ => feedbackStep threshold lowerTarget upperTarget lowerGain upperGain) n x
    L ≤ output ∧ output ≤ U := by
  apply scheduledRun_preserves_interval
  · intro k state hstate
    exact feedbackStep_preserves_interval hl hu hgl hgu hstate
  · exact hx

/-- A proof-carrying controller exposes only interval-safe outputs. -/
def safeFeedback {L U threshold lowerTarget upperTarget lowerGain upperGain : ℝ}
    (hl : L ≤ lowerTarget ∧ lowerTarget ≤ U)
    (hu : L ≤ upperTarget ∧ upperTarget ≤ U)
    (hgl : 0 ≤ lowerGain ∧ lowerGain ≤ 1)
    (hgu : 0 ≤ upperGain ∧ upperGain ≤ 1) :
    {x : ℝ // L ≤ x ∧ x ≤ U} → {x : ℝ // L ≤ x ∧ x ≤ U} :=
  fun x => ⟨feedbackStep threshold lowerTarget upperTarget lowerGain upperGain x.val,
    feedbackStep_preserves_interval hl hu hgl hgu x.property⟩

end FormalDynamics
