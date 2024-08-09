complete -C 'C:\Users\jnesta\AppData\Local\Microsoft\WinGet\Packages\Hashicorp.Terraform_Microsoft.Winget.Source_8wekyb3d8bbwe\terraform.exe' terraform.exe

# - "gb" is short for creating a new git branch, which is a common coding task.
# - We can't use a positional argument in an alias, so we create a function instead.
# - Doing a push is important after creating a new branch because it prevents subsequent `git pull`
#   calls from failing.
gb() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if [ -z "$1" ]; then
    echo "Error: Branch name is required. Usage: gb <branch-name>"
    return 1
  fi

  git checkout master && git pull && git checkout -b feature/jnesta/$1 && git push
}

# "gbc" is short for "git branch clean", which will remove all local branches that do not exist on
# the remote repository.
# https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote
alias gbc='git fetch --prune --quiet && git branch -vv | awk "/: gone]/{print \$1}" | xargs --no-run-if-empty git branch --delete --force; echo; echo "Current git branches:"; git branch'

# "gbl" is short for "git branch list". (The alias of "gb" is already taken by another command.)
alias gbl='git branch'

# "gc" is short for making a commit.
gc() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if [ $# -eq 0 ]; then
    COMMIT_MSG="update"
  else
    COMMIT_MSG="$*"
  fi

  git add --all && git commit -m "$COMMIT_MSG" && git pull && git push && start chrome "https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/$(git rev-parse --show-toplevel | xargs basename)/commit/$(git rev-parse HEAD)"
}

alias gcm='git checkout master && git pull'

# "gco" is short for "git checkout". It requires an argument of the number corresponding to the
# alphbetical local branch.
gco() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    return 1
  fi

  if [[ "$1" =~ ^[0-9]+$ ]]; then
    # First, switch to master so that the below command will not have an asterick next to the
    # feature branches.
    git checkout master

    local branch_number=$1
    local selected_branch=$(git branch | grep -v '^*' | sort | sed -n "${branch_number}p" | tr -d ' ')
    if [ -n "$selected_branch" ]; then
      git checkout "$selected_branch"
    else
      echo "Error: Branch number $branch_number does not exist."
      return 1
    fi
  else
    git checkout "$@"
  fi
}

# "gpr" is short for "git pull request", to start a new PR based on the current branch.
alias gpr='start chrome "https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/$(git rev-parse --show-toplevel | xargs basename)/pullrequestcreate?sourceRef=$(git branch --show-current)"'

# "gtc" is short for "git tags clean", which will remote all local tags that do not exist on the
# remote repository.
# https://stackoverflow.com/questions/1841341/remove-local-git-tags-that-are-no-longer-on-the-remote-repository
alias gtc='git tag -l | xargs git tag -d && git fetch --tags; echo; echo "Current git tags:"; git tag'

alias r='cd /c/Users/jnesta/Repositories'

# "ta" is short for "terraform apply".
alias ta='terraform apply'

# "tc" is short for "terraform clean".
alias tc='rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup'

# "td" is short for "terraform destroy".
alias td='terraform destroy'

# "tf" is short for "terraform fmt".
alias tf='terraform fmt'

# "ti" is short for "terraform init".
alias ti='terraform init'

# "tm" is short for "terraform modules".
alias tm='cd /c/Users/jnesta/Repositories/infrastructure/0_Global_Library/terraform-modules'

# "tv" is short for "terraform validate".
alias tv='terraform validate'
