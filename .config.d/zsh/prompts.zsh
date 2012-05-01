PROMPT='`/Users/burke/src/b/prompt/prompt $?`'

[ $TERM = "eterm-color" ] && setopt singlelinezle
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
