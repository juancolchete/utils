#!/bin/bash

# Define your standard defaults
DEFAULT_USER="juancolchete"
DEFAULT_EMAIL="juancolchete@gmail.com"
DEFAULT_DIR="/__w/juancolchete/reponame"

# Test if $1 contains the word "bot:"
if [[ "$1" == *"bot:"* ]]; then
  # Keep user as default and use $1 as the commit message
  USER_NAME="$DEFAULT_USER"
  USER_EMAIL="${2:-$DEFAULT_EMAIL}"
  SAFE_DIR="${3:-$DEFAULT_DIR}"
  COMMIT_MESSAGE="$1"
else
  # Standard behavior from before
  USER_NAME="${1:-$DEFAULT_USER}"
  USER_EMAIL="${2:-$DEFAULT_EMAIL}"
  SAFE_DIR="${3:-$DEFAULT_DIR}"
  
  # Generate the dynamic fallback commit message
  LAST_COMMIT_MSG=$(git log -1 --pretty=%B)
  LAST_COMMIT_HASH=$(echo -n "$LAST_COMMIT_MSG" | sha256sum | base64)
  HASH_MAX_SIZE=20
  DEFAULT_COMMIT_MESSAGE="bot: ${LAST_COMMIT_HASH:0:$HASH_MAX_SIZE}"
  
  # Use $4 if provided, otherwise use generated default message
  COMMIT_MESSAGE="${4:-$DEFAULT_COMMIT_MESSAGE}"
fi

# Add the directory to git's safe list
git config --global --add safe.directory "$SAFE_DIR"

# Check for changes and push
if [[ -n $(git status --porcelain) ]]; then
  git config --global user.name "$USER_NAME"
  git config --global user.email "$USER_EMAIL"
  git add . 
  git commit -m "$COMMIT_MESSAGE"
  git push
else
  echo "no changes to push"
fi
