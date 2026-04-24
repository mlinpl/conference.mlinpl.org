#!/usr/bin/env bash
# Exit immediately if any command fails
set -e

echo "Updating submodules to latest versions..."
git submodule update --init --recursive --remote

echo "Cleaning up previous builds..."
rm -rf _site
mkdir -p _site

YEARS="2026"
DEFAULT_YEAR="2026"

echo "Building ${DEFAULT_YEAR} site..."
cd "${DEFAULT_YEAR}"
bundle install
bundle exec jekyll build --baseurl "/${DEFAULT_YEAR}" --destination "../_site/${DEFAULT_YEAR}"
cd ..

echo "Copying ${DEFAULT_YEAR} root redirect..."
cp "_site/${DEFAULT_YEAR}/index.html" "_site/index.html"

echo "Generating 404 Redirect..."
export DEFAULT_YEAR="${DEFAULT_YEAR}"
export YEARS_PATTERN=$(echo "${YEARS}" | tr ' ' '|')
envsubst < _templates/404.html > _site/404.html

echo "Starting Jekyll server..."
bundle exec jekyll serve --baseurl "" --skip-initial-build