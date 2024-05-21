# ⬆️ Lean update action

<!-- [![GitHub - marketplace](https://img.shields.io/badge/marketplace-lean-update-blue?logo=github&style=flat-square)](https://github.com/marketplace/actions/lean-update) -->

This [GitHub Action](https://github.com/features/actions) is for Lean projects which include Mathlib as a dependency. Since both Lean and Mathlib are in rapid development, it is important to keep up to date with the latest version. This action aims to make this process smoother.

⚠️  **This action is currently in alpha version and functionality could change significantly prior to version 1 release.**

Any input concerning desired functionality or potential problems is very welcome. Please open an [issue](https://github.com/oliver-butterley/lean-update/issues) or add to ongoing conversations.

The action [attempts to update](#description-of-functionality) Lean and Mathlib. If an update is available then the updated version is tested. This allows for automatic committing of the updated project, opening PRs or opening issues.

Quick setup: add the following to the repo's Github workflow steps.

```yml
- name: Update Lean project
  uses: oliver-butterley/lean-update@v1-alpha
```

See below for [detailed configuration suggestions](#typical-applications) for typical applications.

## :gear: Description of functionality

The action starts by checking if the project has mathlib as a dependency and aborts if this isn't the case. It then updates `lean-toolchain` to match the latest version of mathlib. It then attempts `lake update`. Assuming this is successful then the action attempts to build the project with the updated version. This might be successful or not. Consequently, there are three possible results:

- No update available
- Update available and build successful
- Update available and build fails

By default the action is silent in all cases but can be configured to commit the updated project, opens an issue, open a pull request.

- In order to control what to do when an update is available and the build is successful set `on_update_succeeds` to be equal to `silent`, `commit`, `issue` or `pr` (default: `silent`).

- In order to control what to do when an update is available and the build fails set `on_update_fails` to be equal to `silent`, `issue` or `fail` (default: `silent`).

## 🚀 Typical applications

The action is useful when run periodically (using [cron syntax](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07)) and so a typical use would be to add to a github repo containing a Lean project the file `.github/workflows/update.yml` containing something like the following examples.

### Example 1

Commit updates (exterior to action) or silent:

```yml
name: Update Lean
on:
  schedule:
    - cron: "0 8 * * *" # every day at 8:00 UTC
  workflow_dispatch: # allow manual starts

jobs:
  update_lean:
    runs-on: ubuntu-latest
    permissions:
      contents: write # required to commit to the repo
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Update Lean project
        id: try-update
        uses: oliver-butterley/lean-update@v1-alpha
      - name: When update succeeds commit updated version
        if: steps.try-update.outputs.result == 'update-succeeds'
        run: |
          git config user.name "$GITHUB_ACTOR"
          git config user.email "$GITHUB_ACTOR_ID+$GITHUB_ACTOR@users.noreply.github.com"
          git add .
          git commit -m "Updated version from cron job"
          git push
        env:
          GITHUB_ACTOR: ${{ vars.GITHUB_ACTOR }}
          GITHUB_ACTOR_ID: ${{ vars.GITHUB_ACTOR_ID }}
```

### Example 2

Commit updates (using action internal method) or open an issue:

```yml
name: Update Lean
on:
  schedule:
    - cron: "0 11 * * 4" # every Thursday at 11:00 UTC
  workflow_dispatch: # allow manual starts

jobs:
  update_lean:
    runs-on: ubuntu-latest
    permissions:
      issues: write # required to create issues
      contents: write # required to commit to the repo
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Update Lean project
        uses: oliver-butterley/lean-update@v1-alpha
        with:
          on_update_succeeds: commit
          on_update_fails: issue
```

### Example 3

Open a pull request if update succeeds, otherwise do nothing:

```yml
name: Update Lean
on:
  schedule:
    - cron: "0 11 * * 4" # every Thursday at 11:00 UTC
  workflow_dispatch: # allow manual starts

jobs:
  update_lean:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write # required to create pull requests
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Update Lean project
        uses: oliver-butterley/lean-update@v1-alpha
        with:
          on_update_succeeds: pr
```

The relevant permissions are only required if the corresponding options are selected. If the action is set to open pull requests one must explicitly allow GitHub Actions to create pull requests. This setting can be found in a repository's settings under _Actions > General > Workflow_ permissions.
For the action to open an issue, the issue feature must be activated for the repo. This setting can be found in a repository's settings under _General > Features_.

## 📤 Outputs

The action sets `result` with the value of `up-to-date`, `update-succeeds` or `update-fails` depending on the three possible scenarios. Consequently this action can be used to check for available updates and then trigger different tasks. The checked out repository will remain in the state it is after the attempted update. Consequently is ready to commit if the update is successful.

```yml
jobs:
  check_update:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Update lean
        id: try-update
        uses: oliver-butterley/lean-update-action@v1-alpha

      - name: When update succeeds do something
        if: steps.try-update.outputs.result == 'update-succeeds'
        run: echo "Here do something when an update is available and builds successfully"

      - name: When update fails do something
        if: steps.try-update.outputs.result == 'update-fails'
        run: echo "Here do something when an update is available but build fails"
```

## 🔖 Versioning

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/oliver-butterley/lean-update?logo=github&sort=semver)](https://github.com/oliver-butterley/lean-update/releases)

This project uses Github releases and [semantic versioning](https://semver.org/) tags for release management (e.g., v1.0.3).
A major version tag (e.g., v1) is maintained for each version which points to the latest released version.

## 👥 Contributing

Contributions to the project are welcome!

## 🛡️ License

This project is distributed under the terms of the [MIT](https://github.com/oliver-butterley/lean-update/blob/main/LICENSE) license.
