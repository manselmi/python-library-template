# vim: set ft=python :


import re
import sys

repo_name = "{{ cookiecutter.repo_name }}"
namespace = "{{ cookiecutter.namespace }}"
dist_pkg_name = "{{ cookiecutter.distribution_pkg_name }}"
import_pkg_name = "{{ cookiecutter.import_pkg_name }}"

repo_name_pattern = re.compile(r"[0-9a-z]+(?:-[0-9a-z]+)*")
namespace_pattern = re.compile(r"manselmi(?:\.[a-z]+)*")
dist_pkg_name_pattern = re.compile(re.escape(namespace + ".") + repo_name_pattern.pattern)
import_pkg_name_pattern = re.compile(re.escape(namespace + ".") + r"[0-9a-z]+(?:_[0-9a-z]+)*")

for key, value, pattern in [
    ("repo_name", repo_name, repo_name_pattern),
    ("namespace", namespace, namespace_pattern),
    ("distribution_pkg_name", dist_pkg_name, dist_pkg_name_pattern),
    ("import_pkg_name", import_pkg_name, import_pkg_name_pattern),
]:
    if pattern.fullmatch(value) is None:
        print(f"{key} must match pattern: {pattern.pattern}")
        sys.exit(1)
