# Harbor multi-arch images

## How to build

Same as https://github.com/goharbor/harbor, with a patch applied from `patches/<version>.patch`
(originally seeded from https://github.com/goharbor/harbor/compare/v2.13.2...morlay:patch-v2.13.2)
via `just patch`.

See more in `.github/workflows/docker-publish-images.yml`.

## Staying up to date with upstream

This repo tracks new goharbor/harbor releases automatically, with no dependency on any
third-party fork keeping pace:

- `.github/workflows/ensure-patch.yml` runs weekly, checks for a new stable goharbor/harbor
  release, and forward-ports the most recent `patches/<version>.patch` onto it
  (`git apply --3way` against a full clone of goharbor/harbor). On success it commits the new
  patch file and updates `patches/index.json` directly to `main`. On an unresolvable conflict
  it opens a GitHub issue instead and leaves the version bump for later.
- `renovate.json` configures Renovate to treat `patches/index.json` as the source of truth for
  which versions are safe to bump `version` to — it can never propose a version the patch
  workflow hasn't backed yet — and automerges the bump once checks pass.
- `.github/workflows/pin-submodule.yml` runs on Renovate's PR and pins the `harbor` submodule
  gitlink to the commit matching the new `version`, so the merged PR lands with the version
  file, the submodule pointer, and the patch file all consistent in one shot.