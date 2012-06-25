PROMPT='`/Users/burke/src/b/prompt/zsh_prompt $?`'

[ $TERM = "eterm-color" ] && setopt singlelinezle
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
