"""Compile the axiom audit and validate every reported dependency set."""

from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
audit = ROOT / "FormalDynamics" / "AxiomAudit.lean"
expected = set(re.findall(r"^#print axioms (\w+)$", audit.read_text(), re.M))
theorems = {
    name
    for source in (ROOT / "FormalDynamics").glob("*.lean")
    for name in re.findall(r"^theorem\s+(\w+)", source.read_text(), re.M)
}
if expected != theorems | {"safeFeedback"}:
    sys.exit("AxiomAudit.lean must cover every project theorem and safeFeedback.")
allowed = {"propext", "Classical.choice", "Quot.sound"}
result = subprocess.run(
    ["lake", "env", "lean", str(audit.relative_to(ROOT))],
    cwd=ROOT, text=True, capture_output=True,
)
if result.returncode:
    print(result.stdout + result.stderr)
    sys.exit(result.returncode)

seen = set()
for line in result.stdout.splitlines():
    match = re.match(r"'FormalDynamics\.(\w+)' depends on axioms: \[(.*?)\]", line)
    if match:
        name, axioms = match.groups()
        seen.add(name)
        dependencies = {a.strip() for a in axioms.split(",") if a.strip()}
        if dependencies - allowed:
            sys.exit(f"Unexpected axioms for {name}: {dependencies - allowed}")
    else:
        match = re.match(r"'FormalDynamics\.(\w+)' does not depend on any axioms", line)
        if match:
            seen.add(match.group(1))

if seen != expected:
    sys.exit(f"Audit coverage mismatch: missing={expected - seen}, extra={seen - expected}")
print(result.stdout, end="")
print(f"Axiom check passed for {len(seen)} declarations.")
