fpath=("$HOME/.zshrc.d/autocomplete" "$fpath[@]")

# Prompt {{{
PROMPT='$(shell-prompt "$?" "${__shadowenv_data%%:*}" "${__dev_source_dir}")'
setopt prompt_subst
# }}}
# GPG Agent {{{
gpg-agent --daemon >/dev/null 2>&1
function kick-gpg-agent {
  pid=$(ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
  export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent:${pid}:1
}
kick-gpg-agent
export GPG_TTY=$(tty)
# }}}
# Generic Configuration {{{
gh() { cd  "$(gh  "$@")" }
ghs() { cd "$(ghs "$@")" }
ghb() { cd "$(ghb "$@")" }
]gs() { cd "$(]gs "$@")" }
]gb() { cd "$(]gb "$@")" }

function ghs() {
  dev clone $1
}

# }}}
# ZSH options and features {{{
# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# Treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename
# generation, etc.  (An initial unquoted ‘~’ always produces named directory
# expansion.)
setopt EXTENDED_GLOB

# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument  list. This also applies to file
# expansion of an initial ‘~’ or ‘=’.
setopt NOMATCH

# no Beep on error in ZLE.
setopt NO_BEEP

# Remove any right prompt from display when accepting a command line. This may
# be useful with terminals with other cut/paste methods.
setopt TRANSIENT_RPROMPT

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD

setopt auto_pushd
setopt append_history

unsetopt MULTIOS
