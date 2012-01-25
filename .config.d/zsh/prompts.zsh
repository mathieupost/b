function build-prompt() {
    ret=$?
    case "$ret" in 
        0) statcolor="%{$fg[green]%}" ;;
        *) statcolor="%{$fg[red]%}$ret"   ;;
    esac 
    ruby=$(/Users/burke/src/b/prompt/ruby_info)
    git=$(/Users/burke/src/b/prompt/prompt 2>/dev/null)

    turbo=""
    if [[ $RUBY_HEAP_MIN_SLOTS == 1000000 ]] {
      turbo="X"
    }

    case `hostname` in
        espresso.local) pathcolor="%{$fg[cyan]%}"    ;;
        espresso)       pathcolor="%{$fg[cyan]%}"    ;;
        oglaroon)       pathcolor="%{$fg[yellow]%}"  ;;
        li325-53)       pathcolor="%{$fg[magenta]%}" ;;
        *)              pathcolor="%{$fg[red]%}"     ;;
    esac

    echo "$pathcolor%c %{$fg[red]%}$turbo$ruby $git $statcolor%#%{$reset_color%} "
}
PROMPT='`build-prompt`'

function build-rprompt() {
  echo "%{$fg[black]%}%~ %l %h %*%{$fg[white]%}%{$fg[reset]%}"
}
RPROMPT='`build-rprompt`'

[ x$TERM = "xeterm-color" ] && setopt singlelinezle
[ x$TERM = "xdumb" ] && unsetopt zle && PS1='$ '
