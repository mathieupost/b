PS1="$(prompt.zsh)"

export EDITOR=vim
export GOPATH="${HOME}"
export PYTHONPATH="/lib/python2.7/site-packages"

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'
alias uuuuuuu='cd ../../../../../../..'

export PATH="/Users/burke/src/chromium.googlesource.com/chromium/tools/depot_tools:${PATH}"
export PATH="/usr/local/bin:${PATH}"
export PATH="/Users/burke/src/code.google.com/p/go/bin:${PATH}"
export PATH="${HOME}/bin:${PATH}"
export PATH="${HOME}/bin/_git:${PATH}"
export PATH="/usr/local/Cellar/macvim/7.4-71/MacVim.app/Contents/MacOS:${PATH}"
export PATH="${HOME}/.rbenv/shims:${PATH}"
export PATH="${HOME}/.rbenv/bin:${PATH}"

# colours
eval $(gdircolors -b ~/.LS_COLORS)
alias ls="gls --color=auto -F"

tmux() {
  TERM=screen-256color-bce /usr/bin/env tmux "$@"
}

setopt extended_glob

autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup

bindkey -e

# Setup zsh-autosuggestions
source ~/.zsh-autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle

AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=6'




rbenv rehash 2>/dev/null

