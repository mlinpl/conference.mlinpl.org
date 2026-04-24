#!/usr/bin/env bash
set -euo pipefail

BUILD_CONFIG_FILE="${BUILD_CONFIG_FILE:-build-config.yml}"

YEARS_FROM_CONFIG=""
DEFAULT_YEAR_FROM_CONFIG=""
SITE_URL_FROM_CONFIG=""
ROOT_COPY_RULES_FROM_CONFIG=""

if [[ -f "${BUILD_CONFIG_FILE}" ]]; then
  YEARS_FROM_CONFIG=$(ruby -r yaml -e 'cfg = YAML.load_file(ARGV[0]) || {}; years = cfg["years"]; puts(years.is_a?(Array) ? years.map(&:to_s).join(" ") : "")' "${BUILD_CONFIG_FILE}")
  DEFAULT_YEAR_FROM_CONFIG=$(ruby -r yaml -e 'cfg = YAML.load_file(ARGV[0]) || {}; value = cfg["default_year"]; puts(value.nil? ? "" : value.to_s)' "${BUILD_CONFIG_FILE}")
  SITE_URL_FROM_CONFIG=$(ruby -r yaml -e 'cfg = YAML.load_file(ARGV[0]) || {}; value = cfg["site_url"]; puts(value.nil? ? "" : value.to_s)' "${BUILD_CONFIG_FILE}")
  ROOT_COPY_RULES_FROM_CONFIG=$(ruby -r yaml -e 'cfg = YAML.load_file(ARGV[0]) || {}; rules = cfg["root_copies"]; unless rules.is_a?(Array); exit; end; rules.each do |rule|; next unless rule.is_a?(Hash); source = rule["source"].to_s.strip; next if source.empty?; target = rule["target"].to_s.strip; target = source if target.empty?; puts "#{source}\t#{target}"; end' "${BUILD_CONFIG_FILE}")
fi

YEARS="${YEARS:-${YEARS_FROM_CONFIG}}"
DEFAULT_YEAR="${DEFAULT_YEAR:-${DEFAULT_YEAR_FROM_CONFIG}}"
SITE_URL="${SITE_URL:-${SITE_URL_FROM_CONFIG}}"

if [[ -z "${YEARS}" ]]; then
  YEARS="2026"
fi

if [[ -z "${DEFAULT_YEAR}" ]]; then
  DEFAULT_YEAR="2026"
fi

if [[ -z "${SITE_URL}" ]]; then
  SITE_URL="https://conference.mlinpl.org"
fi

UPDATE_SUBMODULES="${UPDATE_SUBMODULES:-false}"
GENERATE_VERSIONS="${GENERATE_VERSIONS:-false}"
GENERATE_SITEMAP_INDEX="${GENERATE_SITEMAP_INDEX:-false}"
COPY_ROOT_FILES="${COPY_ROOT_FILES:-false}"

echo "Build configuration:"
echo "  BUILD_CONFIG_FILE=${BUILD_CONFIG_FILE}"
echo "  YEARS=${YEARS}"
echo "  DEFAULT_YEAR=${DEFAULT_YEAR}"
echo "  SITE_URL=${SITE_URL}"
echo "  UPDATE_SUBMODULES=${UPDATE_SUBMODULES}"
echo "  GENERATE_VERSIONS=${GENERATE_VERSIONS}"
echo "  GENERATE_SITEMAP_INDEX=${GENERATE_SITEMAP_INDEX}"
echo "  COPY_ROOT_FILES=${COPY_ROOT_FILES}"

if [[ "${UPDATE_SUBMODULES}" == "true" ]]; then
  echo "Updating submodules to latest versions..."
  git submodule update --init --recursive --remote
fi

echo "Cleaning up previous builds..."
rm -rf _site
mkdir -p _site

if [[ "${GENERATE_VERSIONS}" == "true" ]]; then
  echo "Initializing versions manifest..."
  echo "{" > _site/versions.json
fi

FIRST_VERSION_ENTRY=true

for year in ${YEARS}; do
  if [[ ! -d "${year}" ]]; then
    echo "Skipping missing year directory: ${year}"
    continue
  fi

  echo "Building ${year} site..."

  if [[ "${GENERATE_VERSIONS}" == "true" ]]; then
    COMMIT_HASH=$(cd "${year}" && git rev-parse --short HEAD)
    BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if [[ "${FIRST_VERSION_ENTRY}" == "true" ]]; then
      FIRST_VERSION_ENTRY=false
    else
      echo "," >> _site/versions.json
    fi

    printf '  "%s": { "commit": "%s", "built_at": "%s" }' "${year}" "${COMMIT_HASH}" "${BUILD_DATE}" >> _site/versions.json
  fi

  (
    cd "${year}"
    bundle install
    bundle exec jekyll build --baseurl "/${year}" --destination "../_site/${year}"
  )
done

if [[ "${GENERATE_VERSIONS}" == "true" ]]; then
  echo >> _site/versions.json
  echo "}" >> _site/versions.json
fi

echo "Copying ${DEFAULT_YEAR} root index..."
cp "_site/${DEFAULT_YEAR}/index.html" "_site/index.html"

if [[ -n "${ROOT_COPY_RULES_FROM_CONFIG}" ]]; then
  echo "Copying configured root pages from ${DEFAULT_YEAR}..."
  while IFS=$'\t' read -r source_relative target_relative; do
    [[ -z "${source_relative}" ]] && continue
    [[ -z "${target_relative}" ]] && continue

    source_path="_site/${DEFAULT_YEAR}/${source_relative}"
    target_path="_site/${target_relative}"

    if [[ -f "${source_path}" ]]; then
      cp "${source_path}" "${target_path}"
      echo "  copied: ${source_relative} -> ${target_relative}"
    else
      echo "  skipped (missing source): ${source_relative}"
    fi
  done <<< "${ROOT_COPY_RULES_FROM_CONFIG}"
fi

DEFAULT_YEAR_404="_site/${DEFAULT_YEAR}/404.html"
if [[ -f "${DEFAULT_YEAR_404}" ]]; then
  echo "Copying ${DEFAULT_YEAR} 404 page to root..."
  cp "${DEFAULT_YEAR_404}" "_site/404.html"
else
  echo "Generating 404 redirect (fallback)..."
  export DEFAULT_YEAR
  export YEARS_PATTERN
  YEARS_PATTERN=$(echo "${YEARS}" | tr ' ' '|')
  envsubst < _templates/404.html > _site/404.html
fi

if [[ "${GENERATE_SITEMAP_INDEX}" == "true" ]]; then
  echo "Generating root sitemap index..."
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
    for year in ${YEARS}; do
      echo "  <sitemap>"
      echo "    <loc>${SITE_URL}/${year}/sitemap.xml</loc>"
      echo "  </sitemap>"
    done
    echo '</sitemapindex>'
  } > _site/sitemap.xml
fi

if [[ "${COPY_ROOT_FILES}" == "true" ]]; then
  echo "Copying root static files..."
  cp CNAME _site/CNAME
  cp robots.txt _site/robots.txt
  cp google*.html _site/ || true
fi

echo "Unified site build finished."
