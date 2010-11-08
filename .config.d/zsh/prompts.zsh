function build-prompt() {
    case "$?" in 
        0) statcolor="%{$fg[green]%}" ;;
        *) statcolor="%{$fg[red]%}"   ;;
    esac 
    git=$(git-prompt)
    ruby=$(rvm-prompt | \
        sed 's/ree-1.8.7-2010.02/✈/')

    p=$(echo `pwd` | \
        sed 's/\/Users\/[^\/]*/\~/' | \
        sed 's/\~\/src\/panda/熊貓/' 
    )

    if [[ $RUBY_HEAP_MIN_SLOTS == 1000000 ]] {
      turbo=" ⚡"
    }

    echo "%{$fg[cyan]%}$p $git%{$fg[red]%}$ruby$turbo $statcolor▸%{$reset_color%} "
}
PS1='`build-prompt`'

[ x$TERM = "xeterm-color" ] && setopt singlelinezle
[ x$TERM = "xdumb" ] && unsetopt zle && PS1='$ '
