<!-- vim: set ft=markdown : -->


# Development guide

1. Run `git fetch -- origin`.

1. Create a new branch off of the `origin/main` branch. For example:

   ```shell
   git switch --create new-branch -- origin/main
   ```

1. Make changes, adding tests for any new code added.

1. Ensure that [pre-commit](https://pre-commit.com/) is installed *and* that the pre-commit Git hook
   is installed for the repository. For example, if Homebrew is installed:

   ```shell
   brew install -- pre-commit
   pre-commit install
   ```

1. Commit changes. The pre-commit Git hook will trigger and attempt to automatically flag and/or fix
   various issues, including tidying up the Python code. If some issues could not automatically be
   fixed, then manually fix them and commit the new changes.

1. Run tests and ensure all tests pass. For example:

   ```shell
   ./build.sh
   ```

1. Push your branch. For example:

   ```shell
   git push --set-upstream -- origin new-branch
   ```

1. Open a PR with the new branch as the source branch and `main` as the target/base branch.

1. After the PR is approved, merge your branch into the `main` branch.
