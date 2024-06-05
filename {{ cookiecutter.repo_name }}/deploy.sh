#!/usr/bin/env bash
# vim: set ft=bash :

# Stop at any error, treat unset vars as errors and make pipelines exit with a non-zero exit code if
# any command in the pipeline exits with a non-zero exit code.
set -o errexit
set -o nounset
set -o pipefail


die() {
  printf "${*}" >&2
  exit 1
}


# https://stackoverflow.com/a/246128
THIS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

ARTIFACT_DIR="${THIS_DIR}/output/artifact"

# List artifacts.
ls -l --si -- "${ARTIFACT_DIR}"

# Determine package name and version.
pushd -- "${ARTIFACT_DIR}" > /dev/null
read -r -d '' PYTHON_PROG << 'EOF' || true
from pathlib import Path
from pkginfo import Wheel
dist = Wheel(next(Path('.').glob('*.whl')))
print('\t'.join([dist.name, dist.version]))
EOF
IFS=$'\t' read -r PACKAGE_NAME PACKAGE_VERSION <<< "$(python -c "${PYTHON_PROG}")"
printf 'Package name: %s\nPackage version: %s\n' "${PACKAGE_NAME}" "${PACKAGE_VERSION}"
popd > /dev/null

# Check if artifacts corresponding to this package version have already been uploaded to
# Artifactory.
TRAP_ARG='rm -f -- "${RESPONSE}"'
TRAP_SIGNALS=(ERR EXIT INT TERM)
RESPONSE="$(mktemp)"
trap "${TRAP_ARG}" "${TRAP_SIGNALS[@]}"
RESPONSE_CODE="$(
  curl \
    --connect-timeout 3 \
    --max-time 60 \
    --output "${RESPONSE}" \
    --retry 5 \
    --silent \
    --write-out '%{http_code}' \
    -- \
    "https://artifactory.manselmi.com/artifactory/api/storage/python-local/${PACKAGE_NAME}/${PACKAGE_VERSION}"
)"
if [[ "${RESPONSE_CODE}" -eq 404 ]]; then
  :  # No existing artifacts were found, so proceed normally.
elif [[ "${RESPONSE_CODE}" -eq 200 ]]; then
  die 'ERROR: artifacts for %s version %s already exist in Artifactory\n' "${PACKAGE_NAME}" "${PACKAGE_VERSION}"
else
  cat -- "${RESPONSE}" >&2
  die 'ERROR: halting due to unexpected response code %s\n' "${RESPONSE_CODE}"
fi

# Upload artifacts to Artifactory.
if [[ -n "${NO_DEPLOY:-}" ]]; then
  printf 'Deployment has been disabled via the NO_DEPLOY environment variable\n'
  exit
fi
find -- "${ARTIFACT_DIR}" -maxdepth 1 -type f \( -name '*.whl' -o -name '*.tar.gz' \) -exec \
  python -m twine ${NO_COLOR:+"--no-color"} upload \
    --disable-progress-bar \
    --non-interactive \
    --repository-url https://artifactory.manselmi.com/artifactory/api/pypi/python-local \
    --verbose \
    -- \
    {} +
