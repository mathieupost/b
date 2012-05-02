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

# function to execute built-in cd
fasd_cd() { [ $# -gt 1 ] && cd "$(fasd -e echo "$@")" || fasd "$@"; }

