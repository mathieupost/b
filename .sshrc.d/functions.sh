e() {
  $EDITOR "$@"
}
vpnc() {
  osascript -e 'tell application "Viscosity" to connect "Chicago VPN"'
}
vpncd() {
  osascript -e 'tell application "Viscosity" to disconnect "Chicago VPN"'
}
vpna() {
  osascript -e 'tell application "Viscosity" to connect "Ashburn VPN"'
}
vpnad() {
  osascript -e 'tell application "Viscosity" to disconnect "Ashburn VPN"'
}
sgb() {
  git branch --list | grep -v '^\*' | selecta | xargs git checkout
}
gfrog() {
  gfro $(gb | g '*' | ap2)
}
gug() {
  guo $(gb | g '*' | ap2)
}
gufg() {
  gufo $(gb | g '*' | ap2)
}
gfd() {
  git fetch origin $(gb | g '*' | ap2) && git reset --hard FETCH_HEAD
}
ap() {
  awk "{print \$$1}"
}
def() {
  ag "def $@"
}
cros_sdk() {
  cd ~/src/coreos
  vagrant ssh -c "coreos/chromite/bin/cros_sdk" || sh -c 'vagrant up && vagrant ssh -c coreos/chromite/bin/cros_sdk'
}
psag() {
  ps aux | g $1 | gvg
}
ghp() {
  local pr_id="$(git symbolic-ref --short HEAD | sed 's/^pr-//')"
  local remote="$(git remote show -n origin | grep "Fetch URL" | sed 's/.*github.com://' | sed 's/\.git$//')"
  if [[ "${pr_id}" =~ '^[0-9]+$' ]] ; then
    open "https://github.com/${remote}/pull/${pr_id}"
  else
    echo "branch not a pr branch: ${pr_id}"
  fi
}
gpr() {
  local pr_id=$1
  git checkout "pr-${pr_id}"
  if [[ $? -gt 0 ]] ; then
    git fetch origin "refs/pull/${pr_id}/head:pr-${pr_id}"
    git checkout "pr-${pr_id}"
  fi
}
gac() {
  if [[ $# -eq 0 ]] ; then
    git commit -av
  else
    git commit -a -m "$*"
  fi
}
gh() {
  cd $(_gh "$@")
}
ghs() {
  cd $(_gh Shopify $1)
}
ghb() {
  cd $(_gh burke $1)
}
fdg() {
  find . | grep "$@"
}
gfr() {
  git fetch "$@" && git reset --hard FETCH_HEAD
}
ggh() {
  open $(git remote show -n origin | grep "github.com:" | head -1 | awk '{print $3}' | sed 's/:/\//' | sed 's#git@#https://#' | sed 's/\.git$//')
}
ghg() {
  open "https://github.com/$1"
}
ghgb() {
  ghg "burke/$1"
}
ghgs() {
  ghg "Shopify/$1"
}
mi() {
  gem install --no-ri --no-rdoc "$@" && rbenv rehash
}
gbt() {
  git branch --track "$1" "origin/$1"
}
up() {
  while [[ ! -d .git ]] && [[ $(pwd) != "/" ]]; do cd ".."; done
}
eachm() {
  # TODO: can't use matcher here because it returns even non-matches.
  #matcher --limit 100000 $1 < ~/.machines | xargs resolve_machine
  :
}

git() {
  local toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
  if [[ "${toplevel}" == "${HOME}" ]] && [[ "$1" == "clean" ]]; then
    >&2 echo "Do NOT run git clean in this repository."
    return
  fi
  command git "$@"
}
