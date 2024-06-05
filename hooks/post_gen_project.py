# vim: set ft=python :


import shutil
from pathlib import Path

path = Path("src").joinpath("{{ cookiecutter.import_pkg_name.replace('.', '/') }}")
path.parent.mkdir(parents=True)
shutil.move(Path("src/_src"), path)
