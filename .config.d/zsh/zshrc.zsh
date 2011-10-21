export NAME="Burke Libbey"
export EMAIL="burke@burkelibbey.org"

export EDITOR="$HOME/bin/vim"
export PAGER="less"

export GIT_AUTHOR_NAME=$NAME
export GIT_COMMITTER_NAME=$NAME
export GIT_AUTHOR_EMAIL=$EMAIL
export GIT_COMMITTER_EMAIL=$EMAIL
export RUBYOPT="rubygems"

# Head of PATH
P="$HOME/bin"
P="$P:/usr/local/share/npm/bin/"
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
HISTSIZE=5000
SAVEHIST=1000

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

#prompt wunjo

# Emacs editing
bindkey -e

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

if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi
