promptinit
# zsh-mime-setup
autoload colors
colors
autoload -Uz zmv # move function
autoload -Uz zed # edit functions within zle
zle_highlight=(isearch:underline)

# Enable ..<TAB> -> ../
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

typeset WORDCHARS="*?_-.~[]=&;!#$%^(){}<>"

# }}}

function git() {
  local toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
  if [[ "${toplevel}" == "${HOME}" ]] && [[ "$1" == "clean" ]]; then
    >&2 echo "Do NOT run git clean in this repository."
    return
  fi
  command git "$@"
}

function ]g() {
  dev cd "$@"
}

function ]gs() {
  dev cd "$@"
}

function ]gb() {
  dev cd "burke/$@"
}

function z() {
  local srcpath
  srcpath="$(
    awk -F ' *= *' '
      $1 == "[srcpath]" { sp = "yes" }
      sp && $1 == "default" { print $2; exit }
    ' < ~/.config/dev
  )"
  dev cd ${srcpath}/$(ls ${srcpath} | fzf --select-1 --query "$@")
}

function gogopr() {
  git add -A .
  git commit -a -m "$*"
  git push origin "$(git branch | grep '*' | awk '{print $2}')"
  dev open pr
}

zle-dev-open-pr() /opt/dev/bin/dev open pr
zle -N zle-dev-open-pr
bindkey 'ø' zle-dev-open-pr # Alt-O ABC Extended
bindkey 'ʼ' zle-dev-open-pr # Alt-O Canadian English

zle-dev-open-github() /opt/dev/bin/dev open github
zle -N zle-dev-open-github
bindkey '©' zle-dev-open-github # Alt-G ABC Extended & Canadian English

zle-dev-open-shipit() /opt/dev/bin/dev open shipit
zle -N zle-dev-open-shipit
bindkey 'ß' zle-dev-open-shipit # Alt-S ABC Extended & Canadian English

zle-dev-open-app() /opt/dev/bin/dev open app
zle -N zle-dev-open-app
bindkey '®' zle-dev-open-app # Alt-R ABC Extended & Canadian English

zle-dev-cd(){ dev cd ${${(z)BUFFER}}; zle .beginning-of-line; zle .kill-line; zle .accept-line }
zle -N zle-dev-cd
bindkey '∂' zle-dev-cd # Alt-D Canadian English

zle-dev-cd() {
  dev cd "${${(z)BUFFER}}"
  zle .beginning-of-line
  zle .kill-line
  zle .accept-line
}
zle -N zle-dev-cd
bindkey '∂' zle-dev-cd # Alt-D Canadian English

zle-checkout-branch() {
  local branch
  branch="$(git branch -l | fzf -f "${${(z)BUFFER}}" | awk '{print $1; exit}')" 
  git checkout "${branch}" >/dev/null 2>&1
  zle .beginning-of-line
  zle .kill-line
  zle .accept-line
}
zle -N zle-checkout-branch
bindkey '∫' zle-checkout-branch # Alt-B Canadian English

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

export DEV_ALLOW_ITERM2_INTEGRATION=1
source ~/.iterm2_shell_integration.zsh
iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $(git rev-parse --abbr-ref HEAD 2> /dev/null)
}

source ~/.nix-profile/etc/profile.d/nix.sh
source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

if [ -f /opt/dev/dev.sh ]; then
  source /opt/dev/dev.sh
fi
if [ -f ~/.acme.sh/acme.sh.env ]; then
  . "/Users/burke/.acme.sh/acme.sh.env"
fi
