#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

if [[ $(git branch --show-current) != main ]]; then
  printf 'Switch to the main branch before running this script.\n' >&2
  exit 1
fi

git pull --ff-only origin main
git add -A

if ! git diff --cached --quiet; then
  git commit -m "Default commit"
fi

git push origin main
