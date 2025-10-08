<!-- vim: set ft=markdown : -->


# {{ cookiecutter.project_name }}

## Pre-commit hooks

The [pre-commit](https://pre-commit.com/) Git hook framework is responsible for automatically
running various checks, including some that automatically enforce code style and attempt to detect
secrets before they may accidentally be committed to the repository. In some cases the code may
automatically be reformatted, while in other cases manual adjustment may be required. Please read
the [CONTRIBUTING](CONTRIBUTING.md) document for more information.

## Running tests

The [tox](https://tox.readthedocs.io/en/latest/) project automates and standardizes test invocation.

To run all tests, please run the `build.sh` script.

One may also pass `tox` arguments through to `pytest`. This allows for running a subset of tests.
For example:

```shell
# run all tests with all supported Python versions
tox

# run all tests with multiple Python versions in parallel
tox -e py310,py311,py312,py313,py314 -p auto

# run all tests marked as unit tests with Python 3.14
tox -e py314 -- -m unit

# run all tests not marked as slow with Python 3.14
tox -e py314 -- -m 'not slow'

# run a single test with Python 3.14, ignoring insufficient coverage
tox -e py314 -- --cov-fail-under=0 -- test/unit/test_version.py::test_version

# run tox with zero or more tox options
tox [tox_options]

# run tox with zero or more tox options and one or more pytest options
tox [tox_options] -- <pytest_options>

# run tox with zero or more tox options and one or more pytest options / positional arguments
tox [tox_options] -- [pytest_options] [-- <pytest_pos_args>]
```
