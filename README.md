# Lean update action

This github action attempts to update lean and dependencies of a lean project, for example mathlib. If an update is available then the updated version is tested. Options permit automatic committing of the updated project, opening PRs or opening issues.

## Usage

```yml
      - name: Update Lean project
        uses:  oliver-butterley/lean-update-action@v1-beta
```
See below for full customization options. Depending on chosen options, some additional permissions are required.

## Quick setup

The action is useful when run periodically (using `cron`) and so a typical use would be to add to a github repo containing a Lean project the file `.github/workflows/update.yml` containing something like the following:

```yml
name: Update Lean
on:
  schedule:
    - cron: "0 11 * * 4"    # every Wednesday at 11:00 UTC
  workflow_dispatch:        # allow manual starts

jobs:
  update_lean:
    runs-on: ubuntu-latest
    permissions:
      issues: write         # required to create issues
      pull-requests: write  # required to create pull requests
      contents: write       # required to commit updates to the repo
    steps:
      - name: Update Lean project
        uses:  oliver-butterley/lean-update-action@v1-beta
```

## Details and custom configuration

The action starts by attempting `lake update`. Assuming this is successful then the it attempts to build the project with the updated version. This might be successful or not. Consequently, there are three possible outcomes:

- No update available
- Update available and build successful
- Update available and build fails

By default the action is silent in the first case, commits the updated project in the second case and opens an issue in the third case. 

```yml
- uses: oliver-butterley/lean-update-action@v1-beta
  with:
    #  What to do when an update is available and the build is successful.
    #  Allowed values: "silent", "commit", "issue" or "pr". Default: "commit".
    on_update_succeeds: commit
    # What to do when an update is available and the build fails.
    # Allowed values: "silent", "issue" or "pr". Default: "issue".
    on_update_fails: issue
```

## Outputs

The action outputs `up-to-date`, `update-succeeds` or `update-fails` depending on the three possible scenarios.

### To do

- Add configuration options for `lake update` so that a particular project can choose to only update some of the dependencies if required.
- Add update details to commit / issue / PR.
- Add configuration options for the case when documentation also needs to be built.
- Add the possibility to cause the action to fail when an update is available but fails to build.
- Use other lean action to confirm that the build is successful.
- Add functionality to not open another issue if the previous one is already open.

## Total customization

One can also use the code in [`action.yml`](action.yml) as inspiration and use such with unlimited possibility of modification directly in a github workflow for any github repo. 
