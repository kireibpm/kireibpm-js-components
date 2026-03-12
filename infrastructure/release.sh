#!/bin/bash

set -euo pipefail

usage() {
  command=$(basename "$0")
  echo ""
  echo -e "SYNOPSIS"
  echo -e "    $command --releaseType=<releaseType> [--git-push] [--remote-name=<remote>]"
  echo ""
  echo -e "DESCRIPTION"
  echo "  Release the root package version, create commit and tag for the new version"
  echo ""
  echo -e "ARGUMENTS"
  echo -e "  --releaseType=releaseType    one of patch, minor, major, prepatch, preminor, premajor, prerelease"
  echo ""
  echo -e "OPTIONS"
  echo -e "  --git-push                   push commit and tag to git remote (default: false)"
  echo -e "  --remote-name=remote         git remote used for push (default: origin)"
  echo -e "  --help                       display this help"
  echo ""
  exit 1
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
BASE_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
GIT_PUSH=false
REMOTE_NAME=origin
RELEASETYPE=""

for i in "$@"; do
  case $i in
    --releaseType=*)
      RELEASETYPE="${i#*=}"
      shift
      ;;
    --git-push)
      GIT_PUSH=true
      shift
      ;;
    --remote-name=*)
      REMOTE_NAME="${i#*=}"
      shift
      ;;
    --help)
      usage
      ;;
  esac
done

if [ -z "$RELEASETYPE" ]; then
  echo "ERROR: --releaseType is required"
  usage
fi

cd "$BASE_DIR" || exit 1

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "ERROR: releases must be created from 'main', got '$CURRENT_BRANCH'"
  exit 1
fi

npm version "$RELEASETYPE" --no-git-tag-version >/dev/null
SEMVER_VERSION=$(node -p "require('./package.json').version")
PACKAGE_NAME=$(node -p "require('./package.json').name")

npm run dist
npm pack --dry-run >/dev/null

git add package.json dist/ README.md gulpfile.js
if git diff --cached --quiet; then
  echo "ERROR: no staged changes found for release"
  exit 1
fi

git commit -m "$PACKAGE_NAME: release v$SEMVER_VERSION"
git tag "$PACKAGE_NAME@$SEMVER_VERSION" -m "$PACKAGE_NAME@$SEMVER_VERSION: release v$SEMVER_VERSION"

if [ "$GIT_PUSH" = true ]; then
  git push "$REMOTE_NAME" HEAD
  git push "$REMOTE_NAME" "$PACKAGE_NAME@$SEMVER_VERSION"
fi

echo "Release $PACKAGE_NAME@$SEMVER_VERSION success!"
