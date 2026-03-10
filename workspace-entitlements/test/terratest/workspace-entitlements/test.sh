#!/bin/bash
# =============================================================================
# Test runner for workspace-entitlements Terratest
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="${SCRIPT_DIR}/test-reports"

mkdir -p "${REPORT_DIR}"

echo "=== Running workspace-entitlements Terratest ==="

cd "${SCRIPT_DIR}"

go mod tidy

go test -v -timeout 30m ./... 2>&1 | tee "${REPORT_DIR}/test-output.txt"

if command -v gotestsum &>/dev/null; then
  gotestsum --junitfile "${REPORT_DIR}/junit.xml" -- -timeout 30m ./...
fi

echo "=== Test complete. Reports in ${REPORT_DIR} ==="
