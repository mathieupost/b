# vi: ft=fish

set fish_greeting ""


# fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

function fish_prompt
  set last_status $status
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal
  printf '%s ' (__fish_git_prompt)
  set_color normal
end

set -x EDITOR vim
set -x VISUAL $EDITOR
set -x GIT_EDITOR $EDITOR
set -x HOMEBREW_EDITOR $EDITOR

set -x PATH /usr/local/bin $PATH
set -x PATH ~/src/github.com/golang/go/bin $PATH
set -x PATH ~/bin $PATH
set -x PATH ~/bin/_git $PATH
set -x PATH ~/.gem/bin $PATH

gpg-agent --daemon >/dev/null 2>&1

function kick-gpg-agent
  set -l pid (ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
  set -gx GPG_AGENT_INFO /Users/burke/.gnupg/S.gpg-agent:$pid:1
end
kick-gpg-agent
set -x GPG_TTY (tty)

awk '
  /^[^#]/ {
    cmd=$0
    sub(/.*?:/, "", cmd)
    gsub(/&&/, "; and", cmd)
    gsub(/\|\|/, "; or", cmd)
    print "function "$1"; "cmd" $argv; end"
  }
' < ~/.sshrc.d/aliases | while read line; eval "$line"; end

eval (gdircolors -c ~/.sshrc.d/LS_COLORS | sed 's/setenv/set -gx/')
function ls
  gls --color=auto -F $argv
end

# Go
set -gx GOPATH="$HOME"
set -gx GOROOT_BOOTSTRAP="$HOME/src/go1.4"

# Java
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)


function e
  eval $EDITOR $argv
end

function gfrog
  gfro (git branch | g '*' | ap2)
end

function gug
  guo (git branch | g '*' | ap2)
end

function gufg
  gufo (git branch | g '*' | ap2)
end

function ap
  awk "{print \$$1}"
end

function psag
  ps aux | g $1 | gvg
end

function gac
  if test (count $argv) -eq 0
    git commit -av
  else
    git commit -a -m "$argv"
  end
end

function gcm
  git commit -m "$argv"
end

function gh
  cd (_gh $argv)
end

function ghs
  cd (_gh Shopify $argv)
end

function ghb
  cd (_gh burke $argv)
end

function fdg
  find . | grep $argv
end

function ggh
  open (git remote show -n origin | grep "github.com:" | head -1 | awk '{print $3}' | sed 's/:/\//' | sed 's#git@#https://#' | sed 's/\.git$//')
end

function ghg
  open "https://github.com/$argv[1]"
end

function ghgb
  ghg "burke/$argv[1]"
end

function ghgs
  ghg "Shopify/$argv[1]"
end

function mi
  gem install --no-ri --no-rdoc $argv
  hash -r
end

function gbt --argument-names 'branch'
  git branch --track "$branch" "origin/$branch"
end

function up
  while test ! -d .git -a (pwd) != "/"
    cd ".."
  end
end

function git
  set -l toplevel (command git rev-parse --show-toplevel 2>/dev/null)
  if test "$toplevel" = "$HOME" -a "$argv[1]" = "clean"
    echo "Do NOT run git clean in this repository." >&2
  else
    command git $argv
  end
end

# function h
#   if test (count $argv) -gt 0 -a -z 
#   if [[ $# -gt 0 && -z "${1//[0-9]/}" ]]; then
#     n=$1; shift
#     head "-${n}" "$@"
# else
#   head "$@"
#   fi
# end

# function t
#   if [[ $# -gt 0 && -z "${1//[0-9]/}" ]]; then
#     n=$1; shift
#     tail "-${n}" "$@"
# else
#   tail  "$@"
#   fi
# end

function tnp
  set -l n $argv[1]
  set -e argv[1]
  tail "-n+$n" $argv
end

function s3putpublic --argument-names 'file'
  s3cmd put --acl-public "$file" "s3://burkelibbey/$file"
end

function gy --argument-names 'name'
  if [[ -f "$(git rev-parse --show-toplevel)/.git/refs/heads/$name" ]]; then
    git checkout "$name"
  else
    git checkout -b "$name"
  end
end


function ]gs
  _]g "$HOME/src/github.com/Shopify" $argv
  cd "$HOME/src/github.com/Shopify/$project"
end

function ]gb
  _]g "$HOME/src/github.com/burke" $argv
  cd "$HOME/src/github.com/burke/$project"
end

function ]hs
  _]g "$HOME/src/github.com/Shopify" $argv
  open "https://github.com/Shopify/$project"
end

function ]hsn
  local id=$1;shift
  _]g "$HOME/src/github.com/Shopify" $argv
  open "https://github.com/Shopify/$project/pull/$id"
end

function ]hbn
  local id=$1;shift
  _]g "$HOME/src/github.com/burke" $argv
  open "https://github.com/burke/$project/pull/$id"
end

function ]hb
  _]g "$HOME/src/github.com/burke" $argv
  open "https://github.com/burke/$project"
end

function ]hsp
  _]g "$HOME/src/github.com/Shopify" $argv
  open "https://github.com/Shopify/$project/pulls"
end

function ]hbp
  _]g "$HOME/src/github.com/burke" $argv
  open "https://github.com/burke/$project/pulls"
end

function ]hsm
  _]g "$HOME/src/github.com/Shopify" $argv
  open "https://github.com/Shopify/$project/pulls/burke"
end

function ]hbm
  _]g "$HOME/src/github.com/burke" $argv
  open "https://github.com/burke/$project/pulls/burke"
end

function _]g --argument-names 'dir'
  if test (count $argv) -eq 0
    ls "$dir" | awk -F/ '{print $NF}'
    return
  end
  set project (find "$dir" -type d -maxdepth 1 -mindepth 1 | awk -F/ '{print $NF}' | matcher $argv | head -1)
end



if test -f /opt/dev/dev.fish
  source /opt/dev/dev.fish
end
