function build-prompt() {
    case "$?" in 
        0) statcolor="%{$fg[green]%}" ;;
        *) statcolor="%{$fg[red]%}"   ;;
    esac 
    git=$(git-prompt)
    ruby=$(rvm-prompt)

    p=$(echo `pwd` | \
        sed 's/\/Users\/[^\/]*/\~/' | \
        sed 's/\~\/src\/panda/熊貓/' 
    )

    echo "%{$fg[cyan]%}$p $git%{$fg[red]%}$ruby $statcolor▸%{$reset_color%} "
}
PS1='`build-prompt`'

[ x$TERM = "xeterm-color" ] && setopt singlelinezle
[ x$TERM = "xdumb" ] && unsetopt zle && PS1='$ '
