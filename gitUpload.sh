LAST_COMMIT_MSG=$(git log -1 --pretty=%B)
LAST_COMMIT_HASH=$(echo -n $LAST_COMMIT_MSG | sha256sum)
COMMIT_MESSAGE="bot: $LAST_COMMIT_HASH"
git config --global --add safe.directory $3
if [[ `git status --porcelain` ]]; then
  git config --global user.name "$1"
  git config --global user.email "$2"
  git add . 
  git commit -m $COMMIT_MESSAGE
  git push
else
  echo "no changes to push"
fi
