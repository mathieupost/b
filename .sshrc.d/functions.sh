e()     { $EDITOR "$@"; }
sgb()   { git branch --list | grep -v '^\*' | selecta | xargs git checkout; }
gfrog() { gfro $(git branch | g '*' | ap2); }
gug()   { guo $(git branch | g '*' | ap2); }
gufg()  { gufo $(git branch | g '*' | ap2); }
ap()    { awk "{print \$$1}"; }
psag()  { ps aux | g $1 | gvg; }
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
ggh() { open $(git remote show -n origin | grep "github.com:" | head -1 | awk '{print $3}' | sed 's/:/\//' | sed 's#git@#https://#' | sed 's/\.git$//'); }
ghg() { open "https://github.com/$1"; }
ghgb() { ghg "burke/$1"; }
ghgs() { ghg "Shopify/$1"; }
mi() { gem install --no-ri --no-rdoc "$@" && rbenv rehash; }
gbt() { git branch --track "$1" "origin/$1"; }
up() { while [[ ! -d .git ]] && [[ $(pwd) != "/" ]]; do cd ".."; done; }

git() {
  local toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
  if [[ "${toplevel}" == "${HOME}" ]] && [[ "$1" == "clean" ]]; then
    >&2 echo "Do NOT run git clean in this repository."
    return
  fi
  command git "$@"
}

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

gy() {
  local br; br=$1
  if [[ -f "$(git rev-parse --show-toplevel)/.git/refs/heads/${br}" ]]; then
    git checkout "${br}"
  else
    git checkout -b "${br}"
  fi
}
