# Verification

Verification date: 2026-10-05.

## Verified environment

| Component | Verified value |
|---|---|
| Lean | `4.19.0`, release build, commit `6caaee842e94`, `x86_64-unknown-linux-gnu` |
| Lake | `5.0.0-6caaee8` with Lean `4.19.0` |
| mathlib | Release `v4.19.0`, commit `c44e0c8ee63ca166450922a373c7409c5d26b00b` |
| Dependency lock | Nine Git packages, including mathlib, pinned in `lake-manifest.json` |
| OS | Linux x86_64, reported kernel `6.18.44` |
| Project Lean source files | 11 |
| Theorem declarations | 38 |
| Audited declarations | 39: every theorem plus `safeFeedback` |

## Executed build and checks

The final `lake build` exited with status **0** and printed:

```text
Build completed successfully.
```

There were no compiler errors or warnings in the successful final build. All project modules, including the root import and axiom-audit module, were checked.

The following checks also passed:

- `python3 scripts/check_placeholders.py`: no unresolved proof placeholders in project Lean sources.
- `python3 scripts/check_axioms.py`: all 39 required declarations audited; no dependencies outside the accepted foundational set.
- The theorem index lists all 38 theorem declarations, with no missing or extra entries.
- The direct mathlib revision agrees with the Lake dependency lock.

## Reproduction

With elan, Git, curl, and Python 3 installed, run from the project root:

```bash
MATHLIB_NO_CACHE_ON_UPDATE=1 lake update
lake exe cache get Mathlib.Data.Real.Basic Mathlib.Tactic.Linarith Mathlib.Tactic.Ring Mathlib.Tactic.Positivity
lake build
python3 scripts/check_placeholders.py
python3 scripts/check_axioms.py
```

The update and targeted cache commands were executed successfully. The cache supplied 850 dependency-module artifacts. The update flag avoids downloading the full-library cache, since this project imports only the listed modules and their dependencies.

## Clean rebuild

The project's build directory was deleted, retaining the pinned dependency checkouts and their caches:

```bash
python3 -c 'import shutil; shutil.rmtree(".lake/build")'
lake build
```

The subsequent build exited with status **0**, rebuilt all 11 project Lean source files, and produced no compiler warnings. This was a clean rebuild of the project sources; the dependency packages were not rebuilt from source. GitHub Actions is configured to run the build and verification scripts, but remote CI was not executed as part of this verification.

## Axiom results

Lean reported exactly the following dependency set for each audited declaration:

```text
[propext, Classical.choice, Quot.sound]
```

This includes the inequality `product_le_quarter`, geometry results `midpoint_equidistant` and `dot_square_le_normSq_product`, energy invariant `dampBy_preserves_safe`, and capstone `feedbackRun_preserves_interval`. The complete output is retained in [AXIOM_REPORT.txt](AXIOM_REPORT.txt). No custom proof axioms or incomplete-proof axiom dependencies were reported.

## Material changes from the input archive

| Files | Changes |
|---|---|
| `FormalDynamics/BasicLemmas.lean` | Narrowed mathlib imports and clarified a rewrite-lemma comment |
| `FormalDynamics/RealArithmetic.lean`, `Inequalities.lean` | Reused the shared imports and removed mathematically unnecessary assumptions |
| `FormalDynamics/PiecewiseFunctions.lean`, `ConditionalLogic.lean`, `IndexedStates.lean` | Marked real-valued definitions as noncomputable; simplified one proof; reused shared imports |
| `FormalDynamics/StateInvariants.lean` | Removed invalid real-valued `Repr` derivation, marked definitions noncomputable, added bounded-gain and finite-run safety proofs |
| `FormalDynamics/EuclideanGeometry.lean` | Marked real-valued midpoint noncomputable; added the Gram identity and coordinate Cauchy–Schwarz |
| `FormalDynamics/Capstone.lean` | Added parameterized feedback, convex-relaxation bounds, time-varying finite-run preservation, and a proof-carrying safe-state interface |
| `FormalDynamics/AxiomAudit.lean` | Expanded inspection to all 38 theorems and the safe-state controller |
| `lakefile.toml`, new `lake-manifest.json` | Pinned mathlib by exact commit and locked transitive dependencies |
| `scripts/check_placeholders.py`, new `scripts/check_axioms.py` | Strengthened source scanning and added complete axiom-coverage enforcement |
| `.github/workflows/lean.yml` | Added the axiom check and explicit Python 3 invocation |
| `README.md`, `docs/PROOF_NOTES.md`, `docs/THEOREM_INDEX.md`, `docs/VERIFICATION.md`, new `docs/AXIOM_REPORT.txt` | Updated the mathematical scope, theorem coverage, build procedure, and actual verification results |
| `MANIFEST.sha256` | Refreshed checksums for the final distributable files |

The root import file, `lean-toolchain`, and `.gitignore` retain their original content.

## Scope of verification

The results establish the stated mathematical properties in Lean. Real-valued conditional transitions are noncomputable specifications rather than executable numerical controllers. Stability, convergence, and correctness of an external implementation are outside the proved statements. The distributable excludes dependency caches, build products, and installation tooling.
