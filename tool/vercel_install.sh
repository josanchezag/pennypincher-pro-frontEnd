#!/usr/bin/env bash
# Vercel "installCommand": installs the pinned Flutter SDK, verifying the
# archive's SHA-256 before extracting it, and resolves the locked packages.
#
# Vercel's build image (Amazon Linux 2023) has no Flutter:
# https://vercel.com/docs/builds/build-image
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tool/flutter_sdk.sh
source "${repo_root}/tool/flutter_sdk.sh"

# tar and xz unpack the archive; Flutter needs git (the SDK is a git
# checkout), unzip, which and file:
# https://docs.flutter.dev/get-started/install/linux/web
# Install them from the distribution repositories if missing.
missing=()
for tool in curl sha256sum tar xz git unzip which file; do
  command -v "${tool}" >/dev/null 2>&1 || missing+=("${tool}")
done
if ((${#missing[@]} > 0)); then
  command -v dnf >/dev/null 2>&1 || fail "missing tools (${missing[*]}) and no dnf to install them"
  packages=()
  for tool in "${missing[@]}"; do
    case "${tool}" in
      sha256sum) packages+=(coreutils) ;;
      *) packages+=("${tool}") ;;
    esac
  done
  log "Installing ${packages[*]}"
  dnf install -y --quiet "${packages[@]}"
fi

download_dir="$(mktemp -d)"
trap 'rm -rf "${download_dir}"' EXIT
archive="${download_dir}/flutter.tar.xz"

log "Downloading Flutter ${FLUTTER_VERSION}"
curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
  --retry 3 --retry-delay 5 --output "${archive}" "${FLUTTER_URL}"

log "Verifying SHA-256"
printf '%s  %s\n' "${FLUTTER_SHA256}" "${archive}" | sha256sum --check --strict --quiet -

# Only ever replace a directory this script created (it holds the marker).
marker="${FLUTTER_SDK_DIR}/.vercel-install-sha256"
if [[ -e "${FLUTTER_SDK_DIR}" ]]; then
  [[ -f "${marker}" ]] || fail "${FLUTTER_SDK_DIR} exists and was not created by this script"
  rm -rf "${FLUTTER_SDK_DIR}"
fi

log "Extracting to ${FLUTTER_SDK_DIR}"
mkdir -p "${FLUTTER_SDK_DIR}"
tar --extract --xz --file "${archive}" --directory "${FLUTTER_SDK_DIR}" \
  --strip-components=1 --no-same-owner
rm -f "${archive}"
printf '%s\n' "${FLUTTER_SHA256}" >"${marker}"

# The archive is a git checkout owned by another uid; without this git
# refuses to read it and the tool reports version 0.0.0-unknown.
git config --global --add safe.directory "${FLUTTER_SDK_DIR}"

export PATH="${FLUTTER_SDK_DIR}/bin:${PATH}"
export CI=true
flutter config --no-analytics >/dev/null
dart --disable-analytics >/dev/null

version="$(flutter --version --machine | sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p')"
[[ "${version}" == "${FLUTTER_VERSION}" ]] || fail "expected Flutter ${FLUTTER_VERSION}, got '${version}'"
log "Flutter ${version} ready"

cd "${repo_root}"
flutter pub get --enforce-lockfile
