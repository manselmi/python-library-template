<!-- vim: set ft=markdown : -->


> [!NOTE]
> This repo contains a Python library template I had developed at a previous data engineering org to
> promote
>
> * code reuse
>
> * consistent repository layout
>
> * version string management with [setuptools-scm](https://github.com/pypa/setuptools_scm#readme)
>
> * code style enforecement with [pre-commit](https://pre-commit.com)
>
> * running tests with [tox](https://tox.wiki/en/latest/index.html)
>
> * avoiding [distribution
>   package](https://packaging.python.org/en/latest/glossary/#term-Distribution-Package) (a.k.a.
>   "artifact") name collisions with PyPI, the (public) Python Package Index
>
> * creating installable artifacts according to [PEP 518](https://peps.python.org/pep-0518) and [PEP
>   517](https://peps.python.org/pep-0517)
>
> * automatically building, testing and deploying artifacts to a private Artifactory repo via GitHub
>   webhooks and Jenkins
>
> It is showcased here with permission, as-is, aside from me redacting org-specific information.

# Python library template

This repo contains a [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/README.html)
template to simplify and accelerate creating a new Python library repository.

First, ensure that the `cookiecutter` executable is available. For example, if Homebrew is
installed:

```shell
brew install -- cookiecutter
```

Next, change to the directory where you keep Git repos. Run Cookiecutter via

```shell
cookiecutter -- ssh://git-ssh-alias/manselmi/python-library-template.git
```

to start creating a new Python library from this template, where `git-ssh-alias` is a SSH host alias
in the file `~/.ssh/config`.

While the command runs, you will be prompted for information required to finish creating the
project. Here's what to expect:

1. `project_name`: This name will be added to the README.

1. `project_short_description`: Provide a short description of the project to be included in the
   library's package metadata.

1. `author`: Provide the project author's name to be included in the library's package metadata.

1. `author_email`: Provide the project author's email address to be included in the library's
   package metadata.

1. `github_username`: This is the GitHub username that will host this project.

1. `github_code_owner`: Designate a
   [GitHub code owner](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners).
   If multiple code owners are desired, they may be added to the `.github/CODEOWNERS` file after the
   project has been created.

1. `repo_name`: This the name of the directory containing the project, which must match
   the pattern `[0-9a-z]+(?:-[0-9a-z]+)*`. The default values of the [distribution
   package](https://packaging.python.org/glossary/#term-Distribution-Package) and [import
   package](https://packaging.python.org/glossary/#term-Import-Package) names will be derived from
   this value.

1. `namespace`: To avoid name collisions, the default values of the [distribution
   package](https://packaging.python.org/glossary/#term-Distribution-Package) and [import
   package](https://packaging.python.org/glossary/#term-Import-Package) names will be prefixed by
   this value (which must match the pattern `manselmi(?:\.[a-z]+)*`) followed by a dot (`.`).

1. `distribution_pkg_name`: This is the [distribution
   package](https://packaging.python.org/glossary/#term-Distribution-Package) name of the project,
   which must be prefixed as described previously.

1. `import_pkg_name`: This is the [import
   package](https://packaging.python.org/glossary/#term-Import-Package) name of the project, which
   must be prefixed as described previously.

For example:

| Key                     | Value              |
|-------------------------|--------------------|
| `project_name`          | `Foo Bar`          |
| `repo_name`             | `foo-bar`          |
| `namespace`             | `manselmi`         |
| `distribution_pkg_name` | `manselmi.foo-bar` |
| `import_pkg_name`       | `manselmi.foo_bar` |

After working through all of the prompts, Cookiecutter will automatically finish creating the
project.

Next, navigate to the project directory and run the following to initialize the Git repository as
the code and documentation assumes that the default branch name is `main`:

```shell
git init --initial-branch main
```

Note that `main` is also [GitHub's default branch
name](https://github.blog/changelog/2020-10-01-the-default-branch-for-newly-created-repositories-is-now-main/).

(Please see [Highlights from Git
2.28](https://github.blog/2020-07-27-highlights-from-git-2-28/#introducing-init-defaultbranch)
to learn how to configure Git ≥ 2.28 to make `main` the default name for the initial
branch. Also, I recommend the article [Inclusiveness in Language for Outsiders Looking
In](https://ferd.ca/inclusiveness-in-language-for-outsiders-looking-in.html) for more context.)

Add and commit the project.

Finally, create a new project on GitHub whose name matches `repo_name` and push the `main` branch to
the remote repo.
