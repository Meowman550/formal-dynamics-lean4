# Piecewise Dynamics and Safety Invariants in Lean 4

An independent formalization project covering real arithmetic, nonlinear inequalities, conditional logic, dependent indexing, energy safety, and coordinate Euclidean geometry.

The central result proves interval safety for a parameterized piecewise feedback controller. Each branch may choose a different target and gain. Targets must lie in the safe interval, and gains must lie in `[0,1]`; the switching threshold is unrestricted. A separate induction theorem proves interval preservation for arbitrary finite sequences of time-varying safe transitions. A subtype-based interface carries the interval proof with each state.

## Principal results

| Declaration | Mathematical content |
|---|---|
| `relax_preserves_interval` | Convex relaxation toward a safe target preserves interval bounds |
| `feedbackStep_preserves_interval` | Both branches of the parameterized controller preserve safety |
| `scheduledRun_preserves_interval` | Any finite run of interval-preserving transitions remains safe |
| `safeFeedback` | A controller from proof-carrying safe states to safe states |
| `dampBy_preserves_safe` | Signed gains in `[-1,1]` preserve the squared-velocity energy bound |
| `dampRun_preserves_safe` | Energy safety survives arbitrarily long finite damping runs |
| `dot_square_le_normSq_product` | Coordinate Cauchy–Schwarz derived from the planar Gram identity |
| `pythagorean` | Orthogonality implies the squared-norm Pythagorean identity |

All declarations are in the `FormalDynamics` namespace. See [the theorem index](docs/THEOREM_INDEX.md) for the complete theorem list and [proof notes](docs/PROOF_NOTES.md) for mathematical details.

## Build and checks

Install the official Lean toolchain manager, `elan`, and ensure Git, Python 3, and curl are available. The `lean-toolchain` file selects Lean `v4.19.0`. Mathlib is pinned to the exact commit corresponding to its `v4.19.0` release; `lake-manifest.json` also locks transitive dependencies.

From the extracted project directory:

```bash
MATHLIB_NO_CACHE_ON_UPDATE=1 lake update
lake exe cache get Mathlib.Data.Real.Basic Mathlib.Tactic.Linarith Mathlib.Tactic.Ring Mathlib.Tactic.Positivity
lake build
python3 scripts/check_placeholders.py
python3 scripts/check_axioms.py
```

The update flag skips the automatic full-library cache download. The cache command downloads the precompiled modules used here, together with their imports. The build checks every project theorem. The axiom checker elaborates `AxiomAudit.lean` and validates the reported dependency sets for every theorem and the proof-carrying controller. Exact version, build, and audit results are recorded in [verification](docs/VERIFICATION.md).

## Structure

| Module | Purpose |
|---|---|
| `BasicLemmas` | Shared imports and reusable order/algebra lemmas |
| `RealArithmetic` | Affine interval bounds and polynomial identities |
| `Inequalities` | Product, quartic, and parameterized quadratic bounds |
| `PiecewiseFunctions` | Branch reasoning for a real-valued penalty |
| `ConditionalLogic` | Threshold-based mode selection and exclusivity |
| `IndexedStates` | Componentwise bounds on states indexed by `Fin n` |
| `StateInvariants` | Energy safety under dissipative transitions |
| `EuclideanGeometry` | Squared distance, midpoint, orthogonality, and Cauchy–Schwarz |
| `Capstone` | Fixed and parameterized piecewise controllers, finite runs, and safe-state subtypes |
| `AxiomAudit` | Explicit dependency inspection for all project theorems |

The root `FormalDynamics.lean` imports every module. Proofs use `simp`, `rw`, `by_cases`, `linarith`, `nlinarith`, `ring`, induction, and supporting lemmas. GitHub Actions runs the build and both verification scripts.

## Scope

The real-valued transitions are mathematical definitions. They are not numerical simulation implementations. The safety predicates establish interval or energy bounds; they do not assert stability, convergence, physical fidelity, or safety of an external implementation. The geometry is explicitly two-dimensional and coordinate based.
