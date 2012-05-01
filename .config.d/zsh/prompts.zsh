PROMPT='`/Users/burke/src/b/prompt/prompt $?`'

[ x$TERM = "xeterm-color" ] && setopt singlelinezle
[ x$TERM = "xdumb" ] && unsetopt zle && PS1='$ '
