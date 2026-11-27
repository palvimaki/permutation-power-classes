#!/bin/sh
set -eu
cd "$(dirname "$0")"
python3 checks.py
cd lean
lean --version
lake build
python3 - <<'PY'
from pathlib import Path
import re
import subprocess

# Require one axiom report for each named theorem in Audit.lean.
expected = re.findall(r'^#print axioms (\S+)$', Path('Audit.lean').read_text(), re.M)
if not expected or len(expected) != len(set(expected)):
    raise SystemExit('Empty or repeated audit entry')
report = subprocess.run(['lake', 'env', 'lean', 'Audit.lean'], text=True, stdout=subprocess.PIPE, check=True).stdout
print(report, end='')
standard = {'propext', 'Quot.sound', 'Classical.choice'}
for theorem in expected:
    head = "'" + re.escape(theorem) + "' "
    messages = re.findall(head + r'(does not depend on any axioms|depends on axioms:\s*\[[^\]]*\])', report)
    if len(messages) != 1:
        raise SystemExit('Missing or repeated axiom report for ' + theorem)
    match = re.search(r'\[([^\]]*)\]', messages[0])
    axioms = {word.strip() for word in match[1].split(',') if word.strip()} if match else set()
    if axioms - standard:
        raise SystemExit('Unexpected axioms for ' + theorem + ' ' + str(axioms - standard))
print(f'All {len(expected)} theorem audits passed.')
PY
