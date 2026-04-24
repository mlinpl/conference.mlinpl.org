#!/usr/bin/env bash
# Strict mode:
# -e: exit immediately on command failure
# -u: fail on unset variables
# -o pipefail: fail a pipeline if any command in it fails
set -euo pipefail

UPDATE_SUBMODULES=true \
GENERATE_VERSIONS=false \
GENERATE_SITEMAP_INDEX=false \
COPY_ROOT_FILES=false \
bash scripts/build_unified_site.sh

echo "Starting Jekyll server..."
bundle install
bundle exec jekyll serve --baseurl "" --skip-initial-build
