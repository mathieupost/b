# eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install posix-alias)"

# add zsh hook
_fasd_preexec() {
  { eval "fasd --proc $(fasd --sanitize $3)"; } >> "/dev/null" 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook preexec _fasd_preexec

# zsh command mode completion
_fasd_zsh_cmd_complete() {
  local compl
  read -c compl
  compstate[insert]=menu # no expand
  reply=(${(f)"$(fasd --complete "$compl")"})
}

# enbale command mode completion
compctl -U -K _fasd_zsh_cmd_complete -V fasd -x 'C[-1,-*e],s[-]n[1,e]' -c -   'c[-1,-A][-1,-D]' -f -- fasd fasd_cd

# zsh word mode completion
_fasd_zsh_word_complete() {
  [ "$2" ] && local _fasd_cur="$2"
  [ -z "$_fasd_cur" ] && local _fasd_cur="${words[CURRENT]}"
  local fnd="${_fasd_cur//,/ }"
  local typ=${1:-e}
  fasd --query $typ $fnd | sort -nr | sed 's/^[0-9.]*[ ]*//' |     while read line; do
      compadd -U -V fasd "$line"
    done
  compstate[insert]=menu # no expand
}
_fasd_zsh_word_complete_f() { _fasd_zsh_word_complete f ; }
_fasd_zsh_word_complete_d() { _fasd_zsh_word_complete d ; }
_fasd_zsh_word_complete_trigger() {
  local _fasd_cur="${words[CURRENT]}"
  eval $(fasd --word-complete-trigger _fasd_zsh_word_complete $_fasd_cur)
}
# define zle widgets
zle -C fasd-complete 'menu-select' _fasd_zsh_word_complete
zle -C fasd-complete-f 'menu-select' _fasd_zsh_word_complete_f
zle -C fasd-complete-d 'menu-select' _fasd_zsh_word_complete_d

# enable word mode completion
zstyle ':completion:*' completer _complete _ignored   _fasd_zsh_word_complete_trigger

# function to execute built-in cd
fasd_cd() { [ $# -gt 1 ] && cd "$(fasd -e echo "$@")" || fasd "$@"; }
alias j='fasd_cd -d'

