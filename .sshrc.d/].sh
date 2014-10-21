function ]gs() {
  ]g "${HOME}/src/github.com/shopify" "$@"
}

function ]gb() {
  ]g "${HOME}/src/github.com/burke" "$@"
}

function ]g() {
  dir=$1;shift
  if [[ $# -eq 0 ]]; then
    cd "${dir}"
    ls
    return
  fi
  result="$(cd "${dir}" && find . -type d -maxdepth 1 -mindepth 1 | sed 's#./##' | matcher "$@" | head -1)"
  cd "${dir}/${result}"
}
