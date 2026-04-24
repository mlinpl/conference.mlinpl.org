# Contributing to conference.mlinpl.org

## Project structure

- Year-specific conference sites (for example `2026/`) are Git submodules.
- Generated site output is in `_site/`.

Do not edit generated files in `_site/` directly.

### Year sites are submodules

Directories like `2026/` are separate repositories linked as submodules (for example, `2026` points to `https://github.com/mlinpl/conference2026.mlinpl.org`).

If a change belongs to a specific year website:
- make the change in that year repository,
- commit and merge it there first,
- then update the submodule pointer in this repository to the new commit.

Do not treat year site code as owned directly by this repository.

### Deployment workflow and submodule triggers

Deployment is handled by the GitHub Actions workflow in `.github/workflows/deploy.yml`.

The workflow runs when:
- code is pushed to `main` in this repository,
- it is started manually (`workflow_dispatch`),
- it receives a `repository_dispatch` event with type `submodule_update`.

This means year-site repositories can trigger a rebuild of the unified site after they publish changes. In addition, this workflow updates submodules to their latest remote commits during the build.

### Build configuration

The unified build configuration is defined in `build-config.yml`.

- `years`: list of year subdirectories to build
- `default_year`: year used for the root index redirect
- `site_url`: base URL used in generated sitemap index
- `root_copies`: files copied from `_site/<default_year>/...` to `_site/...` (`target` is optional; defaults to `source`)

Update `build-config.yml` when adding or changing supported years.

## Local setup

1. Clone the repository.
2. Install Ruby dependencies:

```bash
bundle install
git submodule update --init --recursive
cd <year> && bundle install && cd ..
```

3. Run the local multi-year build and preview server:

```bash
bash run_locally.sh
```

This script:
- updates git submodules,
- rebuilds `_site/`,
- builds configured year editions from `build-config.yml` under `_site/<year>`,
- copies root `404.html` from `_site/<default_year>/404.html` (falls back to `_templates/404.html` redirect if missing),
- starts Jekyll at `http://localhost:4000`.

## Alternative: work only on a year site

If you are only changing one year site and want a faster loop:

```bash
cd <year>
bash run_locally.sh
```

## Contribution workflow

1. Create a branch from `main`:

```bash
git switch -c feature/short-description
```

2. Make focused changes.
3. Verify locally with `bash run_locally.sh`.
4. Commit with a clear message.
5. Open a pull request.

If your change is in a year-site repository, make sure the main site deployment workflow is triggered by submodule update after that change is merged.

Suggested branch prefixes:
- `feature/...`
- `fix/...`
- `chore/...`

## Troubleshooting

- If `_config.yml` changes are not reflected, restart the Jekyll server.
- If output looks stale, stop the server and run `bash run_locally.sh` again.
