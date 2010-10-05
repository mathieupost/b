function linux() { [[ `uname -s` = "Linux"  ]] }
function mac()   { [[ `uname -s` = "Darwin" ]] }

# Bundler
alias bi="bundle install"
alias bl="bundle lock"
alias bp="bundle pack"
alias bu="bundle unlock"
alias  x="bundle exec"

alias ru="rackup"

function gc () {
    if [ x$1 != x ]; then
        git commit -a -m "$*"
    else 
        git commit -a -v
    fi 
}

function gam () {
    git commit --amend -m "$*"
}

# Git
alias   git="hub" # Hub gem.
alias    ga="git add"
alias  gaac="git add .; gac"
alias   gac="gc"
alias   gap="git add -p"
alias    gb="git branch"
alias   gbl="git branch -l"
alias gcaar="git add .; git commit -a --reuse-message=HEAD --amend"
alias  gcar="git commit -a --reuse-message=HEAD --amend"
alias   gcd="git clean -d"
alias   gcm="git commit -m"
alias   gco="git checkout"
alias  gcob="git checkout -b"
alias  gcom="git checkout master"
alias   gcp="git cherry-pick"
alias   gcr="git commit --reuse-message=HEAD --amend"
alias    gd="git pull"
alias   gdu="git push; git pull"
alias  gdts="git stash; git pull; git stash pop"
alias    gf="git diff"
alias    gl="git log"
alias    gm="git merge"
alias    gn="git clone"
alias   grh="git reset HEAD"
alias   gri="git rebase -i"
alias    gs="git stash"
alias   gsa="git stash apply"
alias   gsd="git stash drop"
alias   gsl="git stash list"
alias   gsp="git stash pop"
alias    gt="git status -sb"
alias    gu="git push"
alias   gwc="git whatchanged"
alias    gx="open -a gitx ."

# Rubygems
alias   mp="gem push"
alias   mi="gem install --no-ri --no-rdoc"
alias   mu="gem uninstall"

# Rake
alias   rs="rake spec"
alias  rps="rake 'parallel:spec[4]'"
alias  rdm="rake db:migrate"
alias rdmr="rake db:migrate:redo"
alias rdmd="rake db:migrate:down"
alias  rgi="rake gems:install"


alias xts="bundle exec thin start"

alias r="ruby"

alias se="spec"

function share() {
  src=$1
  dest=$2
  [ $# = 1 ] && dest=$(basename $src)
  echo "http://panda-build/$dest" | pbcopy
  scp $src web@panda-build:apps/panda_inventory/current/public/$dest
}

function e () {
    $EDITOR --no-wait $*
}

function ee () {
    $EDITOR $*
}

rb () {
  if [ x$1 = x ]; then
    rake build *.gemspec
  else 
    rake build $1
  fi
}

gfl() {
    limit=$1
    [ x$limit = x ] && limit=10
    git rev-list --all --objects |
    sed -n $(git rev-list --objects --all |
        cut -f1 -d' ' | git cat-file --batch-check | grep blob |
        sort -n -k3 | tail -n$limit | while read hash type size;
        do
            echo -n "-e s/$hash/$size/p ";
        done) |
    sort -n -k1
}

gcpall() {
    COMMITISH=$1
    git checkout wookie
    git pull
    git cherry-pick $COMMITISH
    git checkout lazer
    git pull
    git cherry-pick $COMMITISH
    git checkout master
    git pull
    git cherry-pick $COMMITISH
    git checkout wookie
}

gpall() {
    curr=$(git branch -l | grep '*' | awk '{print $2}')
    git pull
    for i in {wookie,master,lazer}; do git checkout $i; git merge origin/$i; done
    git checkout $curr
}

gbt() {
  git branch --track $1 origin/$1
}

merge-dance () {
  target=$1
  current=$(git branch -l | grep '*' | awk '{print $2}')
  git pull
  git checkout $target
  git pull
  git merge $current
  git checkout $current
  git merge $target
}
alias mdm="merge-dance master"

find-rakefile () {
  if [ -f $1/Rakefile ]; then
    echo $1
  else 
    echo $(find-rakefile $1/..)
  fi
}

rails-script () {
  rfpath=$(find-rakefile .)
  target=$1; shift
  if [ -f $rfpath/script/rails ]; then 
    $rfpath/script/rails $target $argv
  else
    $rfpath/script/$target $argv
  fi
}

sc () { rails-script "console"  $argv }
ss () { rails-script "server"   $argv }
sg () { rails-script "generate" $argv }
sr () { rails-script "runner"   $argv }
sgm() { rails-script "generate" "migration" $argv }
sgs() { rails-script "generate" "scaffold"  $argv }
sgr() { rails-script "generate" "resource"  $argv }

alias cd..='cd ..'
alias ..='cd ..'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'

alias tarx="tar xf"
function tarc () {
    arg=$1
    tar czf "$1.tgz" "$1"
}

alias chx="chmod +x"
alias cmmi="./configure && make && sudo make install"
alias slime='emacs -e slime'

alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'

alias a='ack'
alias g='grep'
alias t='tail'
alias h='head'
alias L='less'

alias fdg="find . | grep"

alias l='ls'
alias sl='ls'
if mac; then
  alias ls="ls -GF"
else
  alias ls="ls --color=auto -F"
fi
alias cl="clear;ls"
alias ll="ls -l"
alias l.='ls -d .[^.]*'
alias lsd='ls -ld *(-/DN)'

alias b="popd"

alias md='mkdir -p'
alias rd='rmdir'
alias df="df -hT"
alias scs="screen"
alias scr="screen -r"
alias su="su -s /bin/zsh"

if linux; then
  alias sx="startx"
  alias tsl="tail -f /var/log/syslog"
fi
