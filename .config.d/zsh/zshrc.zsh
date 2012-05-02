export NAME="Burke Libbey"
export EMAIL="burke@burkelibbey.org"

export EDITOR="vim"
export PAGER="less"

export GIT_AUTHOR_NAME=$NAME
export GIT_COMMITTER_NAME=$NAME
export GIT_AUTHOR_EMAIL=$EMAIL
export GIT_COMMITTER_EMAIL=$EMAIL
export RUBYOPT="rubygems"

# Head of PATH
P="$HOME/bin"
P="$P:$HOME/.rbenv/bin"
P="$P:$HOME/.cabal/bin"
P="$P:/usr/local/mysql/bin"
P="$P:/usr/local/share/npm/bin"
P="$P:/usr/local/bin"
P="$P:/usr/local/sbin"
P="$P:/opt/local/bin"
P="$P:/usr/local/mysql/bin"
P="$P:/usr/bin"
# Tail of PATH
export PATH="$P:$PATH"

# history
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

setopt \
    appendhistory \
    autocd \
    extendedglob \
    prompt_subst \
    auto_pushd \
    pushd_silent \
    correct

fpath=($fpath $HOME/.config.d/zsh/func)
typeset -U fpath

autoload -Uz colors
colors

. ~/.config.d/zsh/keybindings.zsh
. ~/.config.d/zsh/git.zsh
. ~/.config.d/zsh/prompts.zsh
. ~/.config.d/zsh/titles.zsh
. ~/.config.d/zsh/completion.zsh
. ~/.config.d/zsh/functions.zsh
. ~/.config.d/zsh/aliases.zsh
. ~/.private.zsh

eval "$(rbenv init -)"
eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install posix-alias)"

