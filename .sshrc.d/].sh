function ]gs() {
  _]g "${HOME}/src/github.com/Shopify" "$@"
  cd "${HOME}/src/github.com/Shopify/${project}"
}

function ]gb() {
  _]g "${HOME}/src/github.com/burke" "$@"
  cd "${HOME}/src/github.com/burke/${project}"
}

function ]hs() {
  _]g "${HOME}/src/github.com/Shopify" "$@"
  open "https://github.com/Shopify/${project}"
}

function ]hsn() {
  local id=$1;shift
  _]g "${HOME}/src/github.com/Shopify" "$@"
  open "https://github.com/Shopify/${project}/pull/${id}"
}

function ]hbn() {
  local id=$1;shift
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}/pull/${id}"
}

function ]hb() {
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}"
}

function ]hsp() {
  _]g "${HOME}/src/github.com/Shopify" "$@"
  open "https://github.com/Shopify/${project}/pulls"
}

function ]hbp() {
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}/pulls"
}

function ]hsm() {
  _]g "${HOME}/src/github.com/Shopify" "$@"
  open "https://github.com/Shopify/${project}/pulls/burke"
}

function ]hbm() {
  _]g "${HOME}/src/github.com/burke" "$@"
  open "https://github.com/burke/${project}/pulls/burke"
}

function _]g() {
  local dir=$1;shift
  if [[ $# -eq 0 ]]; then
    ls "${dir}" | awk -F/ '{print $NF}'
    return
  fi
  project="$(find "${dir}" -type d -maxdepth 1 -mindepth 1 | awk -F/ '{print $NF}' | matcher "$@" | head -1)"
}
