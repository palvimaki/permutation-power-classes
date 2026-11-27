#!/bin/sh
set -eu
span_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
cd "$span_dir/../../../lean"
lean --version
lake build
audit_report=$(mktemp)
trap 'rm -f "$audit_report"' EXIT
lake env lean -DwarningAsError=true "$span_dir/Span.lean" > "$audit_report"
diff -u "$span_dir/audit.txt" "$audit_report"
cat "$audit_report"
