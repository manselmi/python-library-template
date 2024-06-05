import importlib.metadata as impm

import pytest
from packaging.version import InvalidVersion, Version

import {{ cookiecutter.import_pkg_name }} as module

DIST_PKG_NAME = "{{ cookiecutter.distribution_pkg_name }}"


def test_version():
    dist_pkg_version = impm.version(DIST_PKG_NAME)
    try:
        Version(dist_pkg_version)
    except InvalidVersion:
        pytest.fail(
            f"The version `{dist_pkg_version}` of distribution package `{DIST_PKG_NAME}` does not "
            "conform to PEP 440: https://www.python.org/dev/peps/pep-0440/"
        )
    module_name = module.__name__
    version_attr = "__version__"
    if not hasattr(module, version_attr):
        pytest.fail(f"The module `{module_name}` does not have a `{version_attr}` attribute.")
    module_version = module.__version__
    if module_version != dist_pkg_version:
        pytest.fail(
            f"The version `{module_version}` from `{module_name}.{version_attr}` does not equal "
            f"the version `{dist_pkg_version}` of distribution package `{DIST_PKG_NAME}`."
        )
