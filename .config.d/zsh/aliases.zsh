function linux() { [[ `uname -s` = "Linux"  ]] }
function mac()   { [[ `uname -s` = "Darwin" ]] }

alias edv="ey deploy -v"

function eyp() {
    ey $@ --app jack --environment jack
}

function eys() {
    ey $@ --app jack_staging --environment jack_staging
}

function xrgm() {
  $EDITOR `bundle exec rails generate migration $1 | tail -n1 | awk '{print $3}'`
}

function def () {
    ack "def $*"
}

function gc () {
    if [ x$1 != x ]; then
        git commit -a -m "$*"
    else 
        git commit -a -v
    fi 
}

function cpip () {
  ip=$(ifconfig en1 | grep inet | awk '{print $2}' | tail -n1)
  echo $ip | pbcopy
  echo $ip
}

function pyserv () {
  echo http://$(ifconfig en1 | grep inet | awk '{print $2}' | tail -n1):8000 | pbcopy
  python -m SimpleHTTPServer
}

function gam () {
    git commit --amend -m "$*"
}

function server {
   ruby -rwebrick -e's=WEBrick::HTTPServer.new(:Port=>9999,:DocumentRoot=>Dir.pwd);trap("INT"){s.stop};s.start' 
}

alias cdd="cd `readlink ~/.autodev`"

alias git-nohub="/usr/local/bin/git"
alias sadjack="cd ~/src/apps/jack ; script/autodev"
alias jack="cd ~/src/apps/jack"
alias sad="script/autodev"
alias ras="cd ~/src/apps/jack ; touch tmp/run_all_specs"
alias raf="cd ~/src/apps/jack ; touch tmp/run_all_features"
alias rab="cd ~/src/apps/jack ; touch tmp/run_all_specs ; touch tmp/run_all_features"
alias ka9="killall -9"
alias k9="kill -9"
alias bi="bundle install"
alias bo="bundle open"
alias bu="bundle update"
alias  x="bundle exec"
alias  xrs="bundle exec rails server"
alias  xrc="bundle exec rails console"
alias  xrg="bundle exec rails generate"
alias xr="bundle exec rake"
alias trt="touch tmp/restart.txt"
alias mcm="git-nohub fetch core master; git-nohub merge FETCH_HEAD && git-nohub push"
alias ru="rackup"
alias cpd="cap production deploy"
alias csd="cap staging deploy"
alias tags="/usr/local/bin/ctags -e **/*.rb"
alias psag="ps aux | grep "
alias   git="hub" # Hub gem.
alias   gtl="git tag -l"
alias    ga="git-nohub add"
alias  gaac="git-nohub add .; gac"
alias   gac="gc"
alias   gap="git-nohub add -p"
alias   gav="git commit -av"
alias    gb="git-nohub branch"
alias   gbl="git-nohub branch -l"
alias gcaar="git-nohub add .; git-nohub commit -a --reuse-message=HEAD --amend"
alias  gcar="git-nohub commit -a --reuse-message=HEAD --amend"
alias   gcd="git-nohub clean -d"
alias   gcm="git-nohub commit -m"
alias   gco="git checkout"
alias  gcob="git checkout -b"
alias  gcom="git checkout master"
alias   gcp="git-nohub cherry-pick"
alias   gcr="git-nohub commit --reuse-message=HEAD --amend"
alias    gd="git-nohub pull"
alias   gdu="git-nohub pull && git-nohub push"
alias  gdts="git-nohub stash; git-nohub pull; git-nohub stash pop"
alias    gf="git-nohub diff"
alias    gl="git-nohub log"
alias   glp="git-nohub log -p" 
alias  glpr="git-nohub log -p --reverse" 
alias    gm="git-nohub merge"
alias    gn="git clone"
alias   grh="git-nohub reset HEAD"
alias   gri="git-nohub rebase -i"
alias   grc="git-nohub rebase --continue"
alias    gs="git-nohub stash"
alias   gsa="git-nohub stash apply"
alias   gsd="git-nohub stash drop"
alias   gsl="git-nohub stash list"
alias   gsp="git-nohub stash pop"
alias    gt="git-nohub status -sb"
alias    gu="git-nohub push"
alias   gwc="git-nohub whatchanged"
alias    gx="open -a gitx ."
alias    gr="git-nohub reset HEAD"
alias   gr1="git-nohub reset 'HEAD^'"
alias   gr2="git-nohub reset 'HEAD^^'"
alias   gro="git-nohub reset"
alias   grh="git-nohub reset --hard HEAD"
alias  grh1="git-nohub reset --hard 'HEAD^'"
alias  grh2="git-nohub reset --hard 'HEAD^^'"
alias  grho="git-nohub reset --hard"

# Rubygems
alias   mp="gem push"
alias   mi="gem install --no-ri --no-rdoc"
alias   mu="gem uninstall"

function mibi() {
    gem install --no-ri --no-rdoc $1
    bundle install
}

# Rake
alias    rs="bundle exec rake spec"
alias   rps="bundle exec rake 'parallel:spec[4]'"
alias   rdm="bundle exec rake db:migrate"
alias  rdmr="bundle exec rake db:migrate:redo"
alias  rdmd="bundle exec rake db:migrate:down"
alias rdres="bundle exec rake db:reset"

alias xts="bundle exec thin start"

alias r="ruby"

alias se="spec"

function e () {
    $EDITOR $* 2>/dev/null
}

alias gvsc="git add . ; git commit -am 'Auto-commit with useless commit message' ; git pull ; git push"

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

ss-b() { DB_ENV=build ss      }
ss-s() { DB_ENV=staging ss    }
ss-p() { DB_ENV=production ss }

sc-b() { DB_ENV=build sc      }
sc-s() { DB_ENV=staging sc    }
sc-p() { DB_ENV=production sc }

sr-b() { DB_ENV=build sr      }
sr-s() { DB_ENV=staging sr    }
sr-p() { DB_ENV=production sr }

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
alias aa='ack -a'
alias aai='ack -ai'
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
