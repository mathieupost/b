gh() { cd $(_gh "$@"); }
ghs() { cd $(_gh Shopify $1); }
ghb() { cd $(_gh burke $1); }

git() {
  local toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
  if [[ "${toplevel}" == "${HOME}" ]] && [[ "$1" == "clean" ]]; then
    >&2 echo "Do NOT run git clean in this repository."
    return
  fi
  command git "$@"
}
