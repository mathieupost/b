vcc() {
  osascript -e 'tell application "Viscosity" to connectall'
}
vcdc() {
  osascript -e 'tell application "Viscosity" to disconnectall'
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
  gem install --no-ri --no-rdoc "$@" && reh
}
gbt() {
  git branch --track "$1" "origin/$1"
}
up() {
  while [[ ! -d .git ]] && [[ $(pwd) != "/" ]]; do cd ".."; done
}

