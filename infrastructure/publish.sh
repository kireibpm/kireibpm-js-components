#!/bin/bash

set -euo pipefail

usage() {
  command=$(basename "$0")
  echo ""
  echo -e "SYNOPSIS"
  echo -e "    $command"
  echo ""
  echo -e "DESCRIPTION"
  echo "  Publish the root package to the npm registry"
  echo ""
  echo -e "OPTIONS"
  echo -e "  --help                       display this help"
  echo ""
  exit 1
}

for i in "$@"; do
  case $i in
    --help)
      usage
      ;;
  esac
done

PACKAGE_NAME=$(node -p "require('./package.json').name")
PACKAGE_VERSION=$(node -p "require('./package.json').version")
PACKAGE_MAIN=$(node -p "require('./package.json').main || ''")
NPM_USER=$(npm whoami)

if [ -n "$PACKAGE_MAIN" ] && [ ! -f "$PACKAGE_MAIN" ]; then
  npm run dist
fi

if [ -n "$PACKAGE_MAIN" ] && [ ! -f "$PACKAGE_MAIN" ]; then
  echo "ERROR: expected entry artifact '$PACKAGE_MAIN' is missing for $PACKAGE_NAME"
  exit 1
fi

npm pack --dry-run >/dev/null
npm publish --ignore-scripts --access public

echo "Published $PACKAGE_NAME@$PACKAGE_VERSION on npm registry as $NPM_USER"
