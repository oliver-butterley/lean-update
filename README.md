# Lean update action

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/oliver-butterley/lean-update-action?logo=github&sort=semver)](https://github.com/oliver-butterley/lean-update-action/releases)

This github action is for Lean projects which include Mathlib as a dependency. The action attempts to update lean and Mathlib. If an update is available then the updated version is tested. Options permit automatic committing of the updated project, opening PRs or opening issues.

> ⚠️ **For the moment it is unclear the correct method for systematically updating a Lean project which depends on mathlib. Consequently the development of this action should be viewed as speculative.**

## Quick setup

The action is useful when run periodically (using [cron syntax](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07)) and so a typical use would be to add to a github repo containing a Lean project the file `.github/workflows/update.yml` containing something like the following:

```yml
name: Update Lean
on:
  schedule:
    - cron: "0 11 * * 4"    # every Thursday at 11:00 UTC
  workflow_dispatch:        # allow manual starts

jobs:
  update_lean:
    runs-on: ubuntu-latest
    permissions:
      issues: write         # required to create issues
      pull-requests: write  # required to create pull requests
      contents: write       # required to commit to the repo
    steps:
      - name: Update Lean project
        uses:  oliver-butterley/lean-update-action@v1-alpha
        with:
          #  Allowed values: "silent", "commit", "issue" or "pr". Default: "commit".
          on_update_succeeds: commit
          # Allowed values: "silent", "issue" or "fail". Default: "issue".
          on_update_fails: issue
```

The relevant permissions are only required if the corresponding options are selected. If the action is set to open pull requests one must explicitly allow GitHub Actions to create pull requests. This setting can be found in a repository's settings under Actions > General > Workflow permissions.
For the action to open an issue, the issue feature must be activated for the repo. This setting can be found in a repository's settings under General > Features.

## Details and custom configuration

The action starts by checking if the project has mathlib as a dependency and aborts if this isn't the case. It then updates `lean-toolchain` to match the latest version of mathlib. It then attempts `lake update`. Assuming this is successful then the action attempts to build the project with the updated version. This might be successful or not. Consequently, there are three possible outcomes:

- No update available
- Update available and build successful
- Update available and build fails

The action is silent in the first case and, by default, commits the updated project in the second case and opens an issue in the third case. 

- In order to control what to do when an update is available and the build is successful set `on_update_succeeds` to be equal to `silent`, `commit`, `issue` or `pr`. 

- In order to control what to do when an update is available and the build fails set `on_update_fails` to be equal to `silent`, `issue` or `fail`.

## Outputs

The action outputs the `outcome` with the value of `up-to-date`, `update-succeeds` or `update-fails` depending on the three possible scenarios. Consequently this action can be used to check for available updates and then trigger different tasks.

```yml
jobs:
  check_update:
    runs-on: ubuntu-latest
    steps:
      - name: Check for update
        id: check
        uses:  oliver-butterley/lean-update-action@v1-alpha
        with:
          on_update_succeeds: silent
          on_update_fails: silent
      - name: When update succeeds
        if: steps.check.outputs.outcome == 'update-succeeds'
        run: echo An update is available and builds successfully
      - name: When update fails
        if: steps.check.outputs.outcome == 'update-fails'
        run: echo An update is available but builds fails
```

### To do

- Add configuration options for `lake update` so that a particular project can choose to only update some of the dependencies if required.
- Add update details to commit / issue / PR. Diff of changed files?
- Add configuration options for the case when documentation also needs to be built.
- Use other lean action to confirm that the build is successful.
- Add functionality to not open another issue if the previous one is already open.

## Total customization

One can also use the code in [`action.yml`](action.yml) as inspiration and use such with unlimited possibility of modification directly in a github workflow for any github repo. 
