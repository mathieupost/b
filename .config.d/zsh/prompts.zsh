function build-prompt() {
  ret=$?
  case "$ret" in
    0) statcolor="%{$fg[green]%}" ;;
    *) statcolor="%{$fg[red]%}$ret"   ;;
  esac
  git=$(/Users/burke/src/b/prompt/prompt 2>/dev/null)

  turbo=""
  if [[ $RUBY_HEAP_MIN_SLOTS == 1000000 ]] {
    turbo="X "
  }

  case `hostname` in
    burke.local) pathcolor="%{$fg[cyan]%}"    ;;
    burke)       pathcolor="%{$fg[cyan]%}"    ;;
    hoth)        pathcolor="%{$fg[yellow]%}"  ;;
    *)           pathcolor="%{$fg[red]%}"     ;;
  esac

  echo "$pathcolor%c %{$fg[red]%}$turbo$git$statcolor%#%{$reset_color%} "
}
PROMPT='`build-prompt`'

[ x$TERM = "xeterm-color" ] && setopt singlelinezle
[ x$TERM = "xdumb" ] && unsetopt zle && PS1='$ '
