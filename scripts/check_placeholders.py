from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
pattern = re.compile(r"\b(?:sorry|admit|sorryAx)\b|\b(?:by|exact|apply)\?|\b(?:TODO|FIXME)\b")
violations = []

for path in sorted(ROOT.rglob("*.lean")):
    if any(part in {".lake", ".git"} for part in path.relative_to(ROOT).parts):
        continue
    text = path.read_text(encoding="utf-8")
    for line_number, line in enumerate(text.splitlines(), start=1):
        if pattern.search(line):
            violations.append((path.relative_to(ROOT), line_number, line.strip()))

if violations:
    for path, line_number, line in violations:
        print(f"{path}:{line_number}: {line}")
    sys.exit(1)

print("Lean source placeholder check passed.")
