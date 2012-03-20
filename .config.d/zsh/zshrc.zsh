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
P="$P:/usr/local/mysql/bin"
P="$P:/usr/local/share/npm/bin"
P="$P:/usr/local/bin"
P="$P:/usr/local/sbin"
P="$P:/opt/local/bin"
P="$P:/usr/local/mysql/bin"
P="$P:/usr/bin"
# Tail of PATH
export PATH="$P:$PATH"

export NODE_PATH="/usr/local/lib/node"

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

#autoload -U promptinit
#promptinit

bindkey -v
bindkey "^B" backward-char
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^F" forward-char
bindkey "^X^F" vi-find-next-char
bindkey "^N" down-line-or-history
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^X^N" infer-next-history
bindkey "^P" up-line-or-history
bindkey "^H" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^X^J" vi-join
bindkey "^K" kill-line
bindkey "^X^K" kill-buffer
bindkey "^U" kill-whole-line
bindkey "^X^B" vi-match-bracket
bindkey "^X^O" overwrite-mode
bindkey "^V" quoted-insert
bindkey "^T" transpose-chars
bindkey "^Y" yank
bindkey "^D" delete-char-or-list
bindkey "^X*" expand-word
bindkey "^XG" list-expand
bindkey "^Xg " list-expand
bindkey "^M" accept-line
bindkey "^J" accept-line
bindkey "^O" accept-line-and-down-history
bindkey "^X^V" vi-cmd-mode
bindkey "^L" clear-screen
bindkey "^X^X" exchange-point-and-mark
bindkey "^Q" push-line
bindkey "^G" send-break
bindkey "^@" set-mark-command
bindkey "^Xu " undo
bindkey "^X^U" undo
bindkey "^_" undo


autoload -Uz colors
colors

#. ~/.config.d/zsh/git.zsh
. ~/.config.d/zsh/prompts.zsh
. ~/.config.d/zsh/titles.zsh
. ~/.config.d/zsh/completion.zsh
. ~/.config.d/zsh/functions.zsh
. ~/.config.d/zsh/aliases.zsh
. ~/.config.d/zsh/osx.zsh
. ~/.config.d/zsh/j/j.sh
. ~/.config.d/zsh/z.zsh
. ~/.private.zsh

function project_precmd() {
  if [ -z $1 ]; then
    export PROJECT_ROOT=$(cd $(project_precmd .); pwd -P)
  else
    if [[ -d $1/.git || -f $1/Rakefile || -f $1/Makefile ]]; then
      echo $1
    else 
      if [[ $(cd $1; pwd -P) == / ]]; then
        echo .
      else 
        echo $(project_precmd $1/..)
      fi
    fi
  fi
}

precmd_functions+=(project_precmd)

# if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


