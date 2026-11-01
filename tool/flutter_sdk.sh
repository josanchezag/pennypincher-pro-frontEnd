# shellcheck shell=bash
# shellcheck disable=SC2034 # the variables are used by the scripts that source this file
# Pinned Flutter SDK shared by tool/vercel_install.sh and tool/vercel_build.sh.
# Sourced, not executed.
#
# FLUTTER_SHA256 is the `sha256` of the 3.24.5 stable entry in
# https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json
# (archive stable/linux/flutter_linux_3.24.5-stable.tar.xz). When upgrading
# Flutter, update the version, the archive and the hash together, and the
# `flutter` constraint in pubspec.yaml, the Dockerfile and the CI workflow.

readonly FLUTTER_VERSION="3.24.5"
readonly FLUTTER_ARCHIVE="stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
readonly FLUTTER_SHA256="a7c82f551a9eae018e078f6bb186171e5a77920d35a3d75a61d9a593d0a9e4ae"
readonly FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_ARCHIVE}"

# Outside the repository so that `dart format .` and `flutter analyze` never
# see the SDK sources. Overridable, e.g. to reuse the SDK of a CI runner.
FLUTTER_SDK_DIR="${FLUTTER_SDK_DIR:-${HOME:?HOME must be set}/.cache/flutter-${FLUTTER_VERSION}}"
readonly FLUTTER_SDK_DIR

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

log() {
  printf '==> %s\n' "$*"
}
