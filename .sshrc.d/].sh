function ]gs() {
  _]g "${HOME}/src/github.com/shopify" "$@"
  cd "${HOME}/src/github.com/shopify/${project}"
}

function ]gb() {
  _]g "${HOME}/src/github.com/burke" "$@"
  cd "${HOME}/src/github.com/burke/${project}"
}

function ]hs() {
  _]g "${HOME}/src/github.com/shopify" "$@"
  open "https://github.com/Shopify/${project}"
}

function ]hb() {
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}"
}

function ]hsp() {
  _]g "${HOME}/src/github.com/shopify" "$@"
  open "https://github.com/Shopify/${project}/pulls"
}

function ]hbp() {
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}/pulls"
}

function ]hsm() {
  _]g "${HOME}/src/github.com/shopify" "$@"
  open "https://github.com/Shopify/${project}/pulls/burke"
}

function ]hbm() {
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}/pulls/burke"
}

function _]g() {
  local dir=$1;shift
  if [[ $# -eq 0 ]]; then
    cd "${dir}"
    ls
    return
  fi
  project="$(cd "${dir}" && find . -type d -maxdepth 1 -mindepth 1 | sed 's#./##' | matcher "$@" | head -1)"
}
