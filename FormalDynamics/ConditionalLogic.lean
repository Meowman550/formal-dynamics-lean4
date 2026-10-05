import FormalDynamics.BasicLemmas

noncomputable section

namespace FormalDynamics

inductive Mode where
  | normal
  | emergency
  deriving DecidableEq, Repr

/-- Select emergency mode exactly when the measured value exceeds the threshold. -/
def selectMode (value threshold : ℝ) : Mode :=
  if threshold < value then Mode.emergency else Mode.normal

/-- Characterization of the emergency branch. -/
theorem emergency_iff {value threshold : ℝ} :
    selectMode value threshold = Mode.emergency ↔ threshold < value := by
  by_cases h : threshold < value
  · simp [selectMode, h]
  · simp [selectMode, h]

/-- Normal mode implies that the threshold is not exceeded. -/
theorem normal_implies_bounded {value threshold : ℝ}
    (hmode : selectMode value threshold = Mode.normal) :
    value ≤ threshold := by
  by_contra hnot
  have habove : threshold < value := lt_of_not_ge hnot
  simp [selectMode, habove] at hmode

/-- Emergency and normal mode cannot hold simultaneously. -/
theorem mode_exclusive {value threshold : ℝ}
    (he : selectMode value threshold = Mode.emergency) :
    selectMode value threshold ≠ Mode.normal := by
  intro hn
  rw [he] at hn
  cases hn

end FormalDynamics
