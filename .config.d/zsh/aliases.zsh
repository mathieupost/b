function linux() { [[ `uname -s` = "Linux"  ]] }
function mac()   { [[ `uname -s` = "Darwin" ]] }

function ul() {
  scp $1 burke@burkelibbey.org:b/
  echo http://burkelibbey.org/$(basename "$1") | pbcopy
}


alias xu="x unicorn -c ~/.uniconf"

alias reh="rbenv rehash && rehash"

alias eda="vim ~/.config.d/zsh/aliases.zsh ; . ~/.config.d/zsh/aliases.zsh"

alias pro="cd ~/src/5/promanager"
alias shop="cd ~/src/s/shopify"
alias to="script/testonly"

alias lol="git-nohub log --pretty=oneline --abbrev-commit --graph --decorate"

alias edv="ey deploy -v"
alias rf="bundle exec rake features"

alias fr="rake -f FastRakefile"

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

function elm () {
  e db/migrate/`ls db/migrate | tail -n1`
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

function gmmf () {
  git fetch mainline $1 && git merge FETCH_HEAD
}

function gsmmfp () {
  git stash && git fetch mainline $1 && git merge FETCH_HEAD && git stash pop
}

alias gmmfm="gmmf master"
alias gsmmfpm="gsmmfp master"

function server {
   ruby -rwebrick -e's=WEBrick::HTTPServer.new(:Port=>9999,:DocumentRoot=>Dir.pwd);trap("INT"){s.stop};s.start' 
}

alias git-nohub="/usr/local/bin/git"
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
alias   gfc="git-nohub diff --cached"
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
alias rR="rake routes"
alias rRg="rake routes | grep"

# Rubygems
alias   mp="gem push"
mi () { gem install --no-ri --no-rdoc $@ && reh }
mir () { mi $@ && fc -e - }
alias   mu="gem uninstall"

function mibi() {
    gem install --no-ri --no-rdoc $@
    bundle install
}

# Rake
alias    rs="bundle exec rake spec"
alias   rdm="bundle exec rake db:migrate"
alias  rdmr="bundle exec rake db:migrate:redo"
alias  rdmd="bundle exec rake db:migrate:down"
alias rdres="bundle exec rake db:reset"

alias r="ruby"

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
