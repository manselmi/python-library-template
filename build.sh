#!/usr/bin/env bash
# vim: set ft=bash :

# Stop at any error, treat unset vars as errors and make pipelines exit with a non-zero exit code if
# any command in the pipeline exits with a non-zero exit code.
set -o errexit
set -o nounset
set -o pipefail


# https://stackoverflow.com/a/246128
THIS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Ensure "output" directory (created below by `build.sh`) is moved to this directory upon success or
# failure so that Jenkins may collect any available JUnit XML reports.
TRAP_ARG='mv -- "${SCRATCH_DIR}/library/output" "${THIS_DIR}" ; rm -fr -- "${SCRATCH_DIR}"'
TRAP_SIGNALS=(ERR EXIT INT TERM)
SCRATCH_DIR="$(mktemp -d)"
trap "${TRAP_ARG}" "${TRAP_SIGNALS[@]}"

# Execute the manual-stage hooks on all files.
pre-commit run --all-files --hook-stage=manual --show-diff-on-failure

# Instantiate a project with default values, then build it. Before building, the instantiated
# project needs to be moved outside of the template project, with files committed to their own Git
# repo so that setuptools-scm may function correctly.
cookiecutter --no-input --output-dir="${SCRATCH_DIR}" -- "${THIS_DIR}"
pushd -- "${SCRATCH_DIR}/library" > /dev/null
git init
git config --local commit.gpgSign false
git add .
git commit -m 'Initial commit'
./build.sh
popd > /dev/null
