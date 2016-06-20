e()     { $EDITOR "$@"; }
vpnc()  { osascript -e 'tell application "Viscosity" to connect "Chicago VPN"'; }
vpncd() { osascript -e 'tell application "Viscosity" to disconnect "Chicago VPN"'; }
vpna()  { osascript -e 'tell application "Viscosity" to connect "Ashburn VPN"'; }
vpnad() { osascript -e 'tell application "Viscosity" to disconnect "Ashburn VPN"'; }
sgb()   { git branch --list | grep -v '^\*' | selecta | xargs git checkout; }
gfrog() { gfro $(git branch | g '*' | ap2); }
gug()   { guo $(git branch | g '*' | ap2); }
gufg()  { gufo $(git branch | g '*' | ap2); }
gfd()   { git fetch origin $(git branch | g '*' | ap2) && git reset --hard FETCH_HEAD; }
ap()    { awk "{print \$$1}"; }
def()   { ag "def $@"; }
psag()  { ps aux | g $1 | gvg; }
cros_sdk() {
  cd ~/src/coreos
  vagrant ssh -c "coreos/chromite/bin/cros_sdk" || sh -c 'vagrant up && vagrant ssh -c coreos/chromite/bin/cros_sdk'
}
ghp() {
  local pr_id="$(git symbolic-ref --short HEAD | sed 's/^pr\///')"
  local remote="$(git remote show -n origin | grep "Fetch URL" | sed 's/.*github.com://' | sed 's/\.git$//')"
  if [[ "${pr_id}" =~ '^[0-9]+$' ]] ; then
    open "https://github.com/${remote}/pull/${pr_id}"
  else
    echo "branch not a pr branch: ${pr_id}"
  fi
}
gpr() {
  git checkout pr/$1
}
gac() {
  if [[ $# -eq 0 ]] ; then
    git commit -av
  else
    git commit -a -m "$*"
  fi
}
gcm() { git commit -m "$*"; }
gh() { cd $(_gh "$@"); }
ghs() { cd $(_gh Shopify $1); }
ghb() { cd $(_gh burke $1); }
fdg() { find . | grep "$@"; }
gfr() { git fetch "$@" && git reset --hard FETCH_HEAD; }
ggh() { open $(git remote show -n origin | grep "github.com:" | head -1 | awk '{print $3}' | sed 's/:/\//' | sed 's#git@#https://#' | sed 's/\.git$//'); }
ghg() { open "https://github.com/$1"; }
ghgb() { ghg "burke/$1"; }
ghgs() { ghg "Shopify/$1"; }
mi() { gem install --no-ri --no-rdoc "$@" && rbenv rehash; }
gbt() { git branch --track "$1" "origin/$1"; }
up() { while [[ ! -d .git ]] && [[ $(pwd) != "/" ]]; do cd ".."; done; }
eachm() {
  # TODO: can't use matcher here because it returns even non-matches.
  #matcher --limit 100000 $1 < ~/.machines | xargs resolve_machine
  :
}

fmm() # search string
{
  local search=$1 ; shift
  grep "${search}" ~/.machines | \
    xargs -n1 resolve_machine
}

ksenv() # env
        # node
{
  local envn=$1 ; shift
  local node=$1 ; shift
  knife node environment "${envn}" "${node}"
}

git() {
  local toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
  if [[ "${toplevel}" == "${HOME}" ]] && [[ "$1" == "clean" ]]; then
    >&2 echo "Do NOT run git clean in this repository."
    return
  fi
  command git "$@"
}
dm()  { docker-machine "$@"; }
dmu() { dm start default; }
dmd() { dm stop default; }
dme() { $(docker-machine env default); }

h() {
  if [[ $# -gt 0 && -z "${1//[0-9]/}" ]]; then
    n=$1; shift
    head "-${n}" "$@"
  else
    head "$@"
  fi
}

t() {
  if [[ $# -gt 0 && -z "${1//[0-9]/}" ]]; then
    n=$1; shift
    tail "-${n}" "$@"
  else
    tail  "$@"
  fi
}

tnp() {
  n=$1; shift
  tail "-n+${n}" "$@"
}

s3putpublic() {
  s3cmd put --acl-public "$1" "s3://burkelibbey/$1"
}

dirty-repos() {
  local pth color reset
  if [[ -t 0 ]]; then
    color="\x1b[31m"
    reset="\x1b[0m"
  fi
  local IFS; IFS=$'\n'
  while read gitdir; do
    pth="${gitdir%/.git}"
    dirty="$(repo-dirty "${pth}")"
    if [[ -n "${dirty}" ]]; then
      echo "${pth/#.\/}\t${color}${dirty}${reset}"
    fi
  done < <(find . -name .git -type d -maxdepth 2 -mindepth 2)
}

update-repos() {
  local pth color reset ok
  if [[ -t 0 ]]; then
    color="\x1b[31m"
    ok="\x1b[32m"
    reset="\x1b[0m"
  fi
  local IFS; IFS=$'\n'
  while read -r gitdir; do
    pth="${gitdir%/.git}"
    dirty="$(repo-dirty "${pth}")"
    if [[ -n "${dirty}" ]]; then
      echo -e "${pth/#.\/}\t${color}${dirty}${reset}"
    else
      (
        if git -C "${pth}" pull origin "$(head-branch-of-repo "${pth}")" >/dev/null 2>&1; then
          echo -e "${pth/#.\/}\t${ok}ok${reset}"
        else
          echo -e "${pth/#.\/}\t${color}failed${reset}"
        fi
      )
    fi
  done < <(find . -name .git -type d -maxdepth 2 -mindepth 2)
}

repo-dirty() {
  local current_branch head_branch
  local pth; pth=$1
  local gitdir; gitdir="${pth}/.git"

  if [[ ! -d "${gitdir}" ]]; then
    return 1
  fi

  current_branch="$(awk -F/ '/ref: refs\/heads\// { print $3 }' < "${gitdir}/HEAD")"
  if [[ -z "${current_branch}" ]]; then
    echo "branch"
  elif [[ "${current_branch}" != "master" ]]; then
    head_branch="$(head-branch-of-repo "${pth}")"
    if [[ "${current_branch}" != "${head_branch}" ]]; then
      echo "branch"
    fi
  elif git -C "${pth}" status --porcelain | grep -q .; then
    echo "dirty"
  fi
}


head-branch-of-repo() {
  local repo; repo=$1

  local cachefile="${repo}/.git/head-branch"

  if [[ ! -d "${repo}/.git" ]]; then
    return 1
  fi

  if [[ -f "${cachefile}" ]]; then
    cat "${cachefile}"
    return 0
  fi

  git -C "${pth}" remote show origin \
    | awk '/HEAD branch/ { print $3 }' \
    > "${cachefile}"

  cat "${cachefile}"
}

dev-projects() {
  local line
  while read -r line; do
    echo "${line}" | awk -F/ '{print $(NF - 1)}'
  done < <(find ~/src/github.com/Shopify -name dev.yml -maxdepth 2 -mindepth 2)
}

gy() {
  local br; br=$1
  if [[ -f "$(git rev-parse --show-toplevel)/.git/refs/heads/${br}" ]]; then
    git checkout "${br}"
  else
    git checkout -b "${br}"
  fi
}
