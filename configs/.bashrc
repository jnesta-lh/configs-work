export COMPANY_CERT_PATH="/c/tls/BEDROOTCA001.crt"

# Fix self-signed certs.
export NODE_EXTRA_CA_CERTS="$COMPANY_CERT_PATH"
export CURL_CA_BUNDLE="$COMPANY_CERT_PATH"
export REQUESTS_CA_BUNDLE="/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/lib/site-packages/certifi/cacert.pem"

# Terraform auto-complete.
complete -C "C:\\Users\\$USERNAME\\AppData\Local\\Microsoft\\WinGet\\Packages\\Hashicorp.Terraform_Microsoft.Winget.Source_8wekyb3d8bbwe\\terraform.exe" terraform.exe

# Terragrunt auto-complete.
complete -C "C:\\Users\\$USERNAME\\AppData\\Local\\Microsoft\\WinGet\\Packages\\Gruntwork.Terragrunt_Microsoft.Winget.Source_8wekyb3d8bbwe\\terragrunt.exe" terragrunt

# asdf
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# A better "ll" alias that shows hidden files.
alias ll="ls -la"

# "ga" is short for "git add --all".
alias ga="git add --all"

# - "gb" is short for creating a new git branch, which is a common coding task.
# - We can't use a positional argument in an alias, so we create a function instead.
# - Doing a push is important after creating a new branch because it prevents subsequent `git pull`
#   calls from failing.
gb() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if [ -z "${1:-}" ]; then
    echo "Error: Branch name is required. Usage: gb <branch-name>"
    return 1
  fi

  if [ -z "$(git status --porcelain)" ]; then
    local stashed_before_branch=false
  else
    git stash push -m "Auto-stash before creating a new git branch"
    local stashed_before_branch=true
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    local main_branch_name="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    local main_branch_name="master"
  else
    echo "Error: There was not a \"main\" branch or \"master\" branch in this repository."
    return 1
  fi

  if [[ "$(git branch --show-current)" != "$main_branch_name" ]]; then
    git switch "$main_branch_name"
  fi

  git pull
  git switch -c "feature/$USERNAME/$1"
  git push

  if [ "$stashed_before_branch" = true ]; then
    git stash pop
  fi
)

# "gbc" is short for "git branch clean", which will remove all local branches that do not exist on
# the remote repository.
# https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote
gbc() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    local main_branch_name="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    local main_branch_name="master"
  else
    echo "Error: There was not a \"main\" branch or \"master\" branch in this repository."
    return 1
  fi

  if [[ "$(git branch --show-current)" != "$main_branch_name" ]]; then
    git switch "$main_branch_name"
  fi

  git fetch --prune --quiet
  git branch -vv | awk "/: gone]/{print \$1}" | xargs --no-run-if-empty git branch --delete --force

  echo
  echo "Current git branches:"
  git --no-pager branch # Cannot use "gbl" because there is no function hoisting in Bash.
)

# "gbl" is short for "git branch list". ("gb" is already taken by another command.)
alias gbl="git --no-pager branch"

# "gc" is short for "git commit", which will perform all the steps involved in making a new commit
# with all unstaged changes.
gc() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if [ $# -eq 0 ]; then
    COMMIT_MSG="update"
  else
    COMMIT_MSG="$*"
  fi

  git add --all
  git commit -m "$COMMIT_MSG"
  git pull
  git push

  gcs
)

# "gcs" is short for "git commit show", which will open a browser to view the last commit.
gcs() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  local commit_sha1=$(git rev-parse HEAD)
  local remote_url=$(git config --get remote.origin.url)
  if echo "$remote_url" | grep -q "github.com"; then
    local repo_info=$(echo "$remote_url" | sed -E 's/.*github\.com[:/]([^/]+)\/([^.]+)(\.git)?$/\1 \2/')
    local owner=$(echo "$repo_info" | cut -d' ' -f1)
    local repo_name=$(echo "$repo_info" | cut -d' ' -f2)
    local commit_url="https://github.com/$owner/$repo_name/commit/$commit_sha1"
  elif echo "$remote_url" | grep -q "azuredevops.logixhealth.com"; then
    local organization_name=$(echo "$remote_url" | awk -F'/' '{print $(NF-3)}')
    local project_name=$(echo "$remote_url" | awk -F'/' '{print $(NF-2)}')
    local repo_name=$(git rev-parse --show-toplevel | xargs basename)
    local commit_url="https://azuredevops.logixhealth.com/$organization_name/$project_name/_git/$repo_name/commit/$commit_sha1"
  else
    echo "Failed to parse the remote URL for this repository."
    return 1
  fi

  if [[ ${BROWSER:-} == "chrome" ]]; then
    start chrome "$commit_url"
  else
    start microsoft-edge:"$commit_url"
  fi
)

# "gd" is shrot for "git diff".
alias gd="git diff"

# "gl" is short for "git log".
alias gl="git log"

# "gsm" is short for "git switch main".
gsm() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    local main_branch_name="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    local main_branch_name="master"
  else
    echo "Error: There was not a \"main\" branch or \"master\" branch in this repository."
    return 1
  fi

  if [[ "$(git branch --show-current)" != "$main_branch_name" ]]; then
    git switch "$main_branch_name"
  fi

  git pull
  echo # Make the cleaned branches easier to see.
  gbc # git branch clean
)

# "gsw" is short for "git switch". It requires an argument of the number corresponding to the
# alphbetical local branch. ("gs" is already taken by another command.)
gsw() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    local main_branch_name="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    local main_branch_name="master"
  else
    echo "Error: There was not a \"main\" branch or \"master\" branch in this repository."
    return 1
  fi

  if [[ "$1" =~ ^[0-9]+$ ]]; then
    # First, switch to the main branch so that the below command will not have an asterick next to
    # the feature branches.
    if [[ "$(git branch --show-current)" != "$main_branch_name" ]]; then
      git switch "$main_branch_name"
    fi

    local branch_number=$1
    local selected_branch=$(git branch | grep -v '^*' | sort | sed -n "${branch_number}p" | tr -d ' ')
    if [ -n "$selected_branch" ]; then
      git switch "$selected_branch"
    else
      echo "Error: Branch number $branch_number does not exist."
      return 1
    fi
  else
    git switch "$@"
  fi
)

# "gp" is short for "git pull".
alias gp="git pull"

# "gpr" is short for "git pull request", to start a new PR based on the current branch.
gpr() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  local remote_url=$(git config --get remote.origin.url)
  if echo "$remote_url" | grep -q "github.com"; then
    echo "TODO: add GitHub logic"
    return 1
  elif echo "$remote_url" | grep -q "azuredevops.logixhealth.com"; then
    local organization_name=$(echo "$remote_url" | awk -F'/' '{print $(NF-3)}')
    local project_name=$(echo "$remote_url" | awk -F'/' '{print $(NF-2)}')
    local repo_name=$(git rev-parse --show-toplevel | xargs basename)
    local branch_name=$(git branch --show-current)
    local pr_url="https://azuredevops.logixhealth.com/$organization_name/$project_name/_git/$repo_name/pullrequestcreate?sourceRef=$branch_name"
  else
    echo "Failed to parse the remote URL for this repository."
    return 1
  fi

  if [[ ${BROWSER:-} == "chrome" ]]; then
    start chrome "$pr_url"
  else
    start microsoft-edge:"$pr_url"
  fi
)

# "gs" is short for "git status".
alias gs="git status --porcelain"

# "gst" is short for "git stash".
alias gst="git stash"

# "gstp" is short for "git stash pop"
alias gstp="git stash pop"

# "gtc" is short for "git tags clean", which will remote all local tags that do not exist on the
# remote repository.
# https://stackoverflow.com/questions/1841341/remove-local-git-tags-that-are-no-longer-on-the-remote-repository
gtc() (
  set -euo pipefail # Exit on errors and undefined variables.

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  git tag -l | xargs git tag -d
  git fetch --tags

  echo
  echo "Current git tags:"
  git tag
)

# "gu" is short for "git push".
alias gu="git push"

# "p" is short for "pulumi".
alias p="pulumi"

# "pu" is short for "pulumi up".
alias pu="pulumi up"

# "pd" is short for "pulumi destroy".
alias pd="pulumi destroy"

# "pr" is short for "pulumi refresh".
alias pr="pulumi refresh"

# "r" is short for switching to the repositories directory.
alias r="cd /c/Users/$USERNAME/Repositories"

# "ta" is short for "terraform apply".
alias ta="terraform apply"

# "tc" is short for "terraform clean".
alias tc="rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup"

# "td" is short for "terraform destroy".
alias td="terraform destroy"

# "tf" is short for "terraform fmt".
alias tf="terraform fmt"

# "ti" is short for "terraform init".
alias ti="terraform init"

# "tm" is short for "terraform modules".
alias tm="cd /c/Users/$USERNAME/Repositories/infrastructure/0_Global_Library/terraform-modules"

# "tv" is short for "terraform validate".
alias tv="terraform validate"

# npm run shortcuts
alias b="npm run build"
alias l="npm run lint"
alias s="npm run start"
alias t="npm run test"
alias u="npm run update"

# Load environment variables.
source ~/.env
