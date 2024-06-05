#!/usr/bin/env bash
# vim: set ft=bash :

# Stop at any error, treat unset vars as errors and make pipelines exit with a non-zero exit code if
# any command in the pipeline exits with a non-zero exit code.
set -o errexit
set -o nounset
set -o pipefail


# https://stackoverflow.com/a/246128
THIS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

OUTPUT_DIR="${THIS_DIR}/output"
ARTIFACT_DIR="${OUTPUT_DIR}/artifact"

# Recreate output directory.
rm -fr -- "${OUTPUT_DIR}"
mkdir -p -- "${OUTPUT_DIR}/report/junit"  # ruff assumes output dir already exists

# Execute the manual-stage hooks on all files.
pre-commit run --all-files --hook-stage=manual --show-diff-on-failure

# Build sdist and wheel artifacts.
python -m build -o "${ARTIFACT_DIR}"

# Ensure artifact metadata passes basic checks.
python -m twine ${NO_COLOR:+"--no-color"} check -- \
  "${ARTIFACT_DIR}"/*.tar.gz \
  "${ARTIFACT_DIR}"/*.whl

# Execute tox environments in parallel using the sdist that's already been built.
python -m tox -p auto --installpkg "${ARTIFACT_DIR}"/*.tar.gz

# Execute tox environments in parallel using the wheel that's already been built.
python -m tox -p auto --installpkg "${ARTIFACT_DIR}"/*.whl
