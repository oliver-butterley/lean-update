# General notes

This project uses Github releases and git tags and [semantic versioning](https://semver.org/) for release management. For example: `v1.7.1` (major / minor / patch).

In short:
- If a release changes inputs, outputs, functionality or contains changes which would break backwards compatibility, bump the major version.
- If a release introduces new features or changes which do not break backwards compatibility (e.g. adds a new input which doesn't affect the other inputs), bump the minor version.
- For bug fixes, bump the patch version.

A major version tag is maintained for each version which points to the latest released version. Users will most often use this major version tag. For example, if the latest version is `v2.7.1`, `v2` should point to `v2.7.1`.

For more information about releasing GitHub actions see the [Using tags for release management](https://docs.github.com/en/actions/creating-actions/about-custom-actions#using-tags-for-release-management) section of the GitHub custom actions documentation.

## Steps to create a release
- Create an issue to track creating the release.
- Create a `release/v{RELEASE_VERSION}` branch (e.g. `release/v2.7.1`).
    - Test the release candidate by pointing an existing test repository to the branch.
    - Make any minor commits related to the release on the release branch.
- Once the release has been validated, create a new release with release notes copied from the `## Unreleased` section of `CHANGELOG.md` and version tag (e.g `v2.7.1`).
- In the case of a minor or patch version, move the major version tag to the latest version. Do this using the [convenience workflow](.github/workflows/update-major-tag.yml).
- Update `CHANGELOG.md` with a new section with the release name and date directly below the `## Unreleased` header, e.g., `## v2.7.1 - 2024-12-21` .
    - If you made updates to the release notes in the GitHub release, add them to `CHANGELOG.md`.
- If there are additional commits on the release branch, merge the release branch back into `main`.

## Special notes for major releases
- Replace all instances of the major version in `README.md` with the updated version.
- Clearly outline in the `README.md` the migration strategy to the new version if it is more involved than bumping the version number.