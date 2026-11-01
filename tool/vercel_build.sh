#!/usr/bin/env bash
# Vercel "buildCommand": validates the build configuration and builds the
# release web bundle into build/web (vercel.json "outputDirectory").
#
# Required environment variables (Vercel project settings, per environment):
#   FLUTTER_API_BASE_URL         e.g. https://api.example.com/api/v1
#   FLUTTER_GOOGLE_CLIENT_ID     e.g. 1234-abcd.apps.googleusercontent.com
#   FLUTTER_GOOGLE_REDIRECT_URI  e.g. https://app.example.com/auth.html
# DEV_LOGIN / FLUTTER_DEV_LOGIN must be unset, empty or "false": the dev
# login is never compiled into this build.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tool/flutter_sdk.sh
source "${repo_root}/tool/flutter_sdk.sh"

# --- Configuration -----------------------------------------------------------
errors=()

for name in FLUTTER_API_BASE_URL FLUTTER_GOOGLE_CLIENT_ID FLUTTER_GOOGLE_REDIRECT_URI; do
  [[ -n "${!name:-}" ]] || errors+=("${name} is not set")
done

for name in DEV_LOGIN FLUTTER_DEV_LOGIN; do
  value="${!name:-}"
  if [[ -n "${value}" && "${value}" != "false" ]]; then
    errors+=("${name}='${value}': the dev login must never be enabled in this build")
  fi
done

api_base_url="${FLUTTER_API_BASE_URL:-}"
client_id="${FLUTTER_GOOGLE_CLIENT_ID:-}"
redirect_uri="${FLUTTER_GOOGLE_REDIRECT_URI:-}"
host_re='[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+'
local_re='(^|[/.])(localhost|127\.|0\.0\.0\.0|\[::1\])'

if [[ -n "${api_base_url}" ]]; then
  [[ "${api_base_url}" =~ ^https://${host_re}/api/v1$ ]] ||
    errors+=("FLUTTER_API_BASE_URL must look like https://<host>/api/v1 (got '${api_base_url}')")
  [[ ! "${api_base_url}" =~ ${local_re} ]] ||
    errors+=("FLUTTER_API_BASE_URL must not point to a local address")
fi
if [[ -n "${redirect_uri}" ]]; then
  [[ "${redirect_uri}" =~ ^https://${host_re}/auth\.html$ ]] ||
    errors+=("FLUTTER_GOOGLE_REDIRECT_URI must look like https://<host>/auth.html (got '${redirect_uri}')")
  [[ ! "${redirect_uri}" =~ ${local_re} ]] ||
    errors+=("FLUTTER_GOOGLE_REDIRECT_URI must not point to a local address")
fi
if [[ -n "${client_id}" ]]; then
  [[ "${client_id}" =~ ^[0-9]+-[0-9a-z]+\.apps\.googleusercontent\.com$ ]] ||
    errors+=("FLUTTER_GOOGLE_CLIENT_ID must be a Google OAuth client id (<number>-<id>.apps.googleusercontent.com)")
fi

if ((${#errors[@]} > 0)); then
  printf 'ERROR: %s\n' "${errors[@]}" >&2
  fail "invalid build configuration; set the variables in Vercel > Settings > Environment Variables"
fi

[[ -x "${FLUTTER_SDK_DIR}/bin/flutter" ]] ||
  fail "Flutter SDK not found in ${FLUTTER_SDK_DIR}; run tool/vercel_install.sh first"
export PATH="${FLUTTER_SDK_DIR}/bin:${PATH}"
export CI=true
cd "${repo_root}"

# vercel.json headers must match nginx.conf and its CSP connect-src must
# allow exactly the origin of FLUTTER_API_BASE_URL.
log "Checking vercel.json against nginx.conf and FLUTTER_API_BASE_URL"
dart tool/check_vercel_config.dart --api-base-url "${api_base_url}"

# --- Build -------------------------------------------------------------------
log "Building web release (API ${api_base_url}, redirect ${redirect_uri})"
flutter build web --release --no-web-resources-cdn \
  --dart-define=API_BASE_URL="${api_base_url}" \
  --dart-define=GOOGLE_CLIENT_ID="${client_id}" \
  --dart-define=GOOGLE_REDIRECT_URI="${redirect_uri}" \
  --dart-define=DEV_LOGIN=false

# --- Verify the bundle -------------------------------------------------------
bundle="build/web"
for file in index.html auth.html auth_callback.js auth.css flutter_bootstrap.js main.dart.js; do
  [[ -f "${bundle}/${file}" ]] || fail "${bundle}/${file} is missing"
done
for forbidden in localhost 127.0.0.1 dev-login; do
  if grep --quiet --fixed-strings "${forbidden}" "${bundle}/main.dart.js"; then
    fail "${bundle}/main.dart.js contains '${forbidden}'"
  fi
done
grep --quiet --fixed-strings "${api_base_url}" "${bundle}/main.dart.js" ||
  fail "${bundle}/main.dart.js does not contain the API base URL"
log "Bundle ready in ${bundle}"
