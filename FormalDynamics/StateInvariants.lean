import FormalDynamics.BasicLemmas

noncomputable section

namespace FormalDynamics

structure SystemState where
  position : ℝ
  velocity : ℝ
  energy : ℝ

/-- Safety requires nonnegative energy and a kinetic proxy bounded by that energy. -/
def Safe (s : SystemState) : Prop :=
  0 ≤ s.energy ∧ s.velocity ^ 2 ≤ s.energy

/-- A dissipative transition: advance position, halve velocity, retain the energy budget. -/
def dampStep (s : SystemState) : SystemState :=
  { position := s.position + s.velocity
    velocity := s.velocity / 2
    energy := s.energy }

/-- One dissipative step preserves the safety invariant. -/
theorem dampStep_preserves_safe (s : SystemState) (hs : Safe s) :
    Safe (dampStep s) := by
  rcases hs with ⟨henergy, hvel⟩
  constructor
  · simpa [dampStep] using henergy
  · dsimp [dampStep]
    nlinarith [sq_nonneg s.velocity]

/-- Two consecutive dissipative steps also preserve safety. -/
theorem dampStep_twice_preserves_safe (s : SystemState) (hs : Safe s) :
    Safe (dampStep (dampStep s)) := by
  exact dampStep_preserves_safe (dampStep s) (dampStep_preserves_safe s hs)

/-- Signed damping permits reversal while keeping the speed multiplier bounded. -/
def dampBy (gain : ℝ) (s : SystemState) : SystemState :=
  { position := s.position + s.velocity
    velocity := gain * s.velocity
    energy := s.energy }

/-- Any gain in [-1,1] preserves the energy safety bound. -/
theorem dampBy_preserves_safe {gain : ℝ} (hg : -1 ≤ gain ∧ gain ≤ 1)
    (s : SystemState) (hs : Safe s) : Safe (dampBy gain s) := by
  rcases hs with ⟨henergy, hvel⟩
  have hgain : gain ^ 2 ≤ 1 := by nlinarith
  have hscaled := mul_le_mul_of_nonneg_right hgain (sq_nonneg s.velocity)
  constructor
  · exact henergy
  · dsimp [dampBy]
    nlinarith [hscaled]

/-- Iterate a dissipative transition for any finite number of steps. -/
def dampRun : Nat → SystemState → SystemState
  | 0, s => s
  | n + 1, s => dampStep (dampRun n s)

/-- Safety is preserved throughout arbitrarily long finite damping runs. -/
theorem dampRun_preserves_safe (n : Nat) (s : SystemState) (hs : Safe s) :
    Safe (dampRun n s) := by
  induction n with
  | zero => simpa [dampRun] using hs
  | succ n ih => exact dampStep_preserves_safe (dampRun n s) ih

end FormalDynamics
