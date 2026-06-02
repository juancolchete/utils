#!/bin/bash

# 1. Assign variables with default fallbacks
USER_NAME="${1:-juancolchete}"
USER_EMAIL="${2:-juancolchete@gmail.com}"
SAFE_DIR="${3:-/__w/juancolchete/reponame}"

# Add the directory to git's safe list
git config --global --add safe.directory "$SAFE_DIR"

# 2. Generate the dynamic fallback commit message
LAST_COMMIT_MSG=$(git log -1 --pretty=%B)
LAST_COMMIT_HASH=$(echo -n "$LAST_COMMIT_MSG" | sha256sum | base64)
HASH_MAX_SIZE=20
DEFAULT_COMMIT_MESSAGE="bot: ${LAST_COMMIT_HASH:0:$HASH_MAX_SIZE}"

# 3. Use $4 if provided, otherwise use the generated default message
COMMIT_MESSAGE="${4:-$DEFAULT_COMMIT_MESSAGE}"

# 4. Check for changes and push
if [[ -n $(git status --porcelain) ]]; then
  git config --global user.name "$USER_NAME"
  git config --global user.email "$USER_EMAIL"
  git add . 
  git commit -m "$COMMIT_MESSAGE"
  git push
else
  echo "no changes to push"
fi
