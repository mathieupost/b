# vim: foldmethod=marker

# Prompt {{{
PROMPT='$(/Users/burke/bin/shell-prompt $? $KEYMAP)'
setopt prompt_subst
# }}}
# EDITOR {{{
export EDITOR=vim
if which vim >/dev/null 2>&1; then
  export EDITOR=vim
fi
export VISUAL="${EDITOR}"
export GIT_EDITOR="${EDITOR}"
export HOMEBREW_EDITOR="${EDITOR}"
# }}}
# PATH {{{
typeset -Ug path
path_add() {
  path=("$1" "$path[@]")
}

path_add /usr/local/bin
path_add $HOME/src/github.com/golang/go/bin
path_add $HOME/bin
path_add $HOME/bin/_git
path_add $HOME/.gem/bin
path_add $HOME/.cargo/bin

fpath=("$HOME/.zshrc.d/autocomplete" "$fpath[@]")
# }}}
# GPG Agent {{{
gpg-agent --daemon >/dev/null 2>&1
function kick-gpg-agent {
  pid=$(ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
  export GPG_AGENT_INFO=/Users/burke/.gnupg/S.gpg-agent:${pid}:1
}
kick-gpg-agent
export GPG_TTY=$(tty)
# }}}
# Aliases, functions {{{
eval $(cat ~/.sshrc.d/aliases \
  | grep -v '^#' \
  | grep -vE '^\s*$' \
  | sed 's/\$/\\$/' \
  | sed 's/"/\\"/g' \
  | sed 's/^\([^ :]*\)[[:space:]]*:[[:space:]]*\(.*\)/alias \1="\2";/')
source "${HOME}/.sshrc.d/functions.sh"
source "${HOME}/.sshrc.d/].sh"
# }}}
# gdircolors {{{
eval $(gdircolors -b ~/.sshrc.d/LS_COLORS)
alias ls="gls --color=auto -F"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
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

autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup
autoload colors
colors
autoload  -Uz zmv # move function
autoload  -Uz zed # edit functions within zle
zle_highlight=(isearch:underline)

# Enable ..<TAB> -> ../
zstyle ':completion:*' special-dirs true

typeset WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

HISTFILE=~/.zsh_history
SAVEHIST=50000
HISTSIZE=50000
# }}}
# Autosuggestions {{{

# Enable autosuggestions automatically
function zle-line-init() {
  zle autosuggest-start
}
zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle

AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=6'
# }}}
# Language-specific settings {{{

# Go
export GOPATH="${HOME}"
export GOROOT_BOOTSTRAP="${HOME}/src/go1.4"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# }}}
# Vim mode {{{
# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi

  zle reset-prompt
  zle -R
}

TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

# These two don't really appear to be necessary.
#zle -N zle-line-init
#zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

bindkey -s -M vicmd H '0'
bindkey -s -M vicmd L '$'
bindkey kj vi-cmd-mode

# slow enough for me to hit "kj", but fast enough that the delay on <esc> isn't jarring.
export KEYTIMEOUT=15

# }}}

#source "${HOME}/.zshrc.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${HOME}/.zshrc.d/zsh-autosuggestions/autosuggestions.zsh"

zle-line-init() {
  zle autosuggest-start
}
zle -N zle-line-init
bindkey '^f' vi-forward-word
bindkey '^b' vi-backward-word
bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^k' kill-line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

export NVIM_TUI_ENABLE_TRUE_COLOR=1

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
