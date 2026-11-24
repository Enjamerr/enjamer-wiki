#!/bin/sh
set -e

case "${1:-}" in
  lint)
    npm run lint -- --max-warnings=0
    ;;
  format)
    npm run format:check
    ;;
  fix-format)
    npm run format
    ;;
  build)
    npm run build
    ;;
  commit-messages)
    base=$(git merge-base main HEAD)
    npx commitlint --from "$base" --to HEAD
    ;;
  current-commit)
    npx commitlint
    ;;
  last-commit)
    npx commitlint --last
    ;;
  branch-name)
    branch=$(git branch --show-current)
    base=$(git merge-base main HEAD)
    node enjamer/scripts/validate-branch.js "$branch" "$base" HEAD
    ;;
  commit-authors)
    base=$(git merge-base main HEAD)
    node enjamer/scripts/validate-commit-authors.js "$base" HEAD
    ;;
  project)
    for check in lint format build commit-messages branch-name commit-authors; do
      sh "$0" "$check"
    done
    ;;
  *)
    printf 'Unknown validation: %s\n' "${1:-}" >&2
    exit 2
    ;;
esac
