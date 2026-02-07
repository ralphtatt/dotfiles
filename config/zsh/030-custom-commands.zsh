# Git
git_pull_all() {
  local base_dir="${1:-.}"

  find "$base_dir" -type d -name ".git" -print0 | while IFS= read -r -d '' gitdir; do
    local repo_dir="${gitdir:h}"

    # Check if uncommited changes
    if git -C "$repo_dir" diff --quiet && git -C "$repo_dir" diff --cached --quiet; then
      echo "updating $repo_dir"
      git -C "$repo_dir" pull
    else
      echo "Skipping $repo_dir (uncommitted changes)"
    fi
  done
}


# Clear kube context
kclear() {
  kubectl config unset current-context
}

