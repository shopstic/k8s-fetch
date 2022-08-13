#!/usr/bin/env bash
set -euo pipefail

build_npm() {
  VERSION=${1:?"Version is required"}
  deno run -A --check ./build-npm.ts "${VERSION}"
}

publish_npm() {
  npm publish ./dist
}

gen_types() {
  local SPEC_URL=${1:-"https://raw.githubusercontent.com/kubernetes/kubernetes/v1.22.12/api/openapi-spec/swagger.json"}
  local DIR="$(dirname "$(realpath "$0")")"

  openapi-ts <(curl -sf "${SPEC_URL}") "$DIR"/openapi-ts-formatter.mjs > "$DIR"/src/types.ts

  "$0" auto_fmt
}

code_quality() {
  echo "Checking for unformatted TypeScript sources"
  deno fmt --check
  echo "Linting all TypeScript sources"
  deno lint
}

auto_fmt() {
  echo "Auto-formatting TypeScript sources"
  deno fmt
}

update_cache() {
  echo "Updating cache"
  deno cache ./src/deps.ts ./build-npm.ts
  echo "All good!"
}

"$@"