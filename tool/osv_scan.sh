#!/usr/bin/env bash
# Scans pubspec.lock with osv-scanner and fails on HIGH or CRITICAL
# findings (CVSS >= 7.0) and on findings without a severity score, which
# need a manual review. Lower severities are reported but do not fail.
# Exceptions live in osv-scanner.toml, each with a reason and an expiry.
#
#   tool/osv_scan.sh [extra osv-scanner flags, e.g. --offline-vulnerabilities]
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"
command -v osv-scanner >/dev/null || { echo "ERROR: osv-scanner not found" >&2; exit 1; }
command -v jq >/dev/null || { echo "ERROR: jq not found" >&2; exit 1; }

report="$(mktemp)"
trap 'rm -f "${report}"' EXIT

# Exit code 1 only means "vulnerabilities found"; anything else is an error.
status=0
osv-scanner scan source --config osv-scanner.toml --lockfile pubspec.lock \
  --format json "$@" >"${report}" || status=$?
if ((status != 0 && status != 1)); then
  echo "ERROR: osv-scanner failed with exit code ${status}" >&2
  exit "${status}"
fi

findings="$(jq -r '
  [.results[]?.packages[]? as $p | $p.groups[]? |
    {pkg: "\($p.package.name)@\($p.package.version)",
     ids: (.ids | join(",")),
     score: (.max_severity // "")}]
  | .[] | "\(.score)\t\(.pkg)\t\(.ids)"' "${report}")"

blocking=0
while IFS=$'\t' read -r score pkg ids; do
  [[ -n "${pkg:-}" ]] || continue
  if [[ -z "${score}" ]] || awk -v s="${score}" 'BEGIN { exit !(s >= 7.0) }'; then
    echo "BLOCKING: ${pkg} ${ids} (CVSS ${score:-unknown})"
    blocking=$((blocking + 1))
  else
    echo "WARNING: ${pkg} ${ids} (CVSS ${score})"
  fi
done <<<"${findings}"

if ((blocking > 0)); then
  echo "ERROR: ${blocking} HIGH/CRITICAL or unscored finding(s) in pubspec.lock." >&2
  echo "Upgrade the package, or document a proven non-applicable finding in osv-scanner.toml." >&2
  exit 1
fi
echo "osv-scanner: no HIGH/CRITICAL findings in pubspec.lock"
