PROMPT='$(/Users/burke/bin/shell-prompt $?)'
setopt prompt_subst

export EDITOR=vim
if which nvim >/dev/null 2>&1; then
  export EDITOR=nvim
fi
export GIT_EDITOR="${EDITOR}"
export HOMEBREW_EDITOR="${EDITOR}"

export GOPATH="${HOME}"
export GOROOT_BOOTSTRAP="${HOME}/src/go1.4"
export PYTHONPATH="/lib/python2.7/site-packages"

export PATH="/Users/burke/src/chromium.googlesource.com/chromium/tools/depot_tools:${PATH}"
export PATH="/usr/local/bin:${PATH}"
export PATH="/Users/burke/src/github.com/golang/go/bin:${PATH}"
export PATH="${HOME}/bin:${PATH}"
export PATH="${HOME}/bin/_git:${PATH}"
export PATH="${HOME}/google-cloud-sdk/bin:${PATH}"
export PATH="${HOME}/.rbenv/shims:${PATH}"
export PATH="${HOME}/.rbenv/bin:${PATH}"

# colours
eval $(gdircolors -b ~/.sshrc.d/LS_COLORS)
alias ls="gls --color=auto -F"

zstyle    ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle    ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
zstyle    ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Enable ..<TAB> -> ../
zstyle ':completion:*' special-dirs true

typeset WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

HISTFILE=~/.zsh_history
SAVEHIST=50000
HISTSIZE=50000

gpg-agent --daemon >/dev/null 2>&1
function kick-gpg-agent {
  pid=$(ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
  export GPG_AGENT_INFO=/Users/burke/.gnupg/S.gpg-agent:${pid}:1
}
kick-gpg-agent

eval $(cat ~/.sshrc.d/aliases \
  | grep -v '^#' \
  | grep -vE '^\s*$' \
  | sed 's/\$/\\$/' \
  | sed 's/^\([^ :]*\)[[:space:]]*:[[:space:]]*\(.*\)/alias \1="\2";/')

source "${HOME}/.sshrc.d/functions.sh"
source "${HOME}/.sshrc.d/].sh"

# If a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# Treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.  (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB

# If a pattern for filename generation has no matches, print an error, instead of leaving it unchanged in the argument  list. This also applies to file expansion of an initial ‘~’ or ‘=’.
setopt NOMATCH

# no Beep on error in ZLE.
setopt NO_BEEP

# Remove  any right prompt from display when accepting a command line. This may be useful with terminals with other cut/paste methods.
setopt TRANSIENT_RPROMPT

# If unset, the cursor is set to the end of the word if completion is started. Otherwise it stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD

setopt auto_pushd
setopt append_history


autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup
autoload  colors                       # use colors
colors
autoload  -Uz zmv                      # move function
autoload  -Uz zed                      # edit functions within zle
zle_highlight=(isearch:underline)

bindkey -e

source ~/.zsh-autosuggestions/autosuggestions.zsh
# source ~/src/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable autosuggestions automatically
zle-line-init() {
  zle autosuggest-start
}
zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle

AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=6'

export GPG_TTY=$(tty)

eval "$(rbenv init -)"

rbenv rehash 2>/dev/null

# OPAM configuration
. /Users/burke/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
