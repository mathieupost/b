function fish_prompt ; ~/src/b/prompt/prompt $status ; end

set fish_greeting ""

function mac ; test (uname -s) = "Darwin" ; end
function linux ; test (uname -s) = "Linux" ; end

set -x CDPATH . $HOME/src/g $HOME/src/s $HOME/src/b $HOME/go/src
set -x EDITOR vim

set -x GOPATH $HOME/go

set -x RUBY_HEAP_MIN_SLOTS 1000000
set -x RUBY_HEAP_SLOTS_INCREMENT 1000000
set -x RUBY_HEAP_SLOTS_GROWTH_FACTOR 1
set -x RUBY_GC_MALLOC_LIMIT 1000000000
set -x RUBY_HEAP_FREE_MIN 500000

set -x DYLD_LIBRARY_PATH /usr/local/Cellar/libtool/2.4.2/lib $DYLD_LIBRARY_PATH

function tmux
  set TERM screen-256color-bce
  /usr/bin/env tmux $argv
end

function c1c ; cut -c1-$COLUMNS ; end

function def          ; ack "def $argv" ; end
function reh          ; rbenv rehash    ; end

function shop         ; cd ~/src/s/shopify ; end
function to           ; script/testonly $argv ; end

function xrgm         ; e (bundle exec rails generate migration $argv[1] | tail -n1 | awk '{print $3}') ; end
function elm          ; e db/migrate/(ls db/migrate | tail -n1) ; end


function gc ; if test $argv[1] ; git commit -a -m "$argv" ; else git commit -a -v ; end ; end

function cpip
  set ip (ifconfig en0 | grep inet | awk '{print $2}' | tail -n1)
  echo $ip | pbcopy
  echo $ip
end

function pyserv
  echo http://(ifconfig en0 | grep inet | awk '{print $2}' | tail -n1):8000 | pbcopy
  python -m SimpleHTTPServer
end

function ka9 ; killall -9 $argv ; end
function k9 ; kill -9 $argv ; end
function psag ; ps aux | grep $argv ; end



######## bundler #############################################################
function bi ; bundle install ; end
function bo ; bundle open $argv ; end
function bu ; bundle update ; end
function bs ; bundle show $argv ; end
function  x ; bundle exec $argv ; end

function ap ; awk "{print \$$argv[1]}" ; end
function ap1 ; awk '{print $1}' ; end
function ap2 ; awk '{print $2}' ; end
function ap3 ; awk '{print $3}' ; end
function ap4 ; awk '{print $4}' ; end
function ap5 ; awk '{print $5}' ; end
function ap6 ; awk '{print $6}' ; end
function ap7 ; awk '{print $7}' ; end
function ap8 ; awk '{print $8}' ; end
function ap9 ; awk '{print $9}' ; end

function xk9 ; xargs kill -9 ; end

function psag ; ps aux | g $argv[1] | gvg ; end

function gvg ; grep -v grep ; end

######## git stuff ###########################################################
function glol ; lol --graph -200 $argv ; end

function lol
  set HASH "%C(yellow)%h%Creset"
  set RELATIVE_TIME "%Cgreen(%ar)%Creset"
  set AUTHOR "%C(blue)<%an>%Creset"
  set REFS "%C(red)%d%Creset"
  set SUBJECT "%s"

  set FORMAT "$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"

  git log -1000 --pretty="tformat:$FORMAT" $argv | sed -Ee 's/(^[^<]*) ago)/\1)/' | sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?)/\1)/' | column -s '}' -t | less -FXRS
end

function grim         ; git rebase -i master; end
function gprunemerged ; git branch --merged | grep -v "\*" | xargs -n 1 git branch -d ; end
function gam          ; git commit --amend -m "$argv" ; end
function gmmf         ; git fetch origin $argv[1]; and git merge FETCH_HEAD ; end
function gsmmfp       ; git stash; and git fetch origin $argv[1]; and git merge FETCH_HEAD; and git stash pop ; end
function gmmfm        ; gmmf master ; end
function gsmmfpm      ; gsmmfp master ; end
function   gtl ; git tag -l ; end
function    ga ; git add $argv ; end
function  gaac ; git add .; gac $argv ; end
function   gac ; gc $argv ; end
function   gap ; git add -p $argv ; end
function   gav ; git commit -av ; end
function    gb ; git branch ; end
function   gbl ; git branch -l ; end
function gcaar ; git add .; git commit -a --reuse-message=HEAD --amend ; end
function  gcar ; git commit -a --reuse-message=HEAD --amend ; end
function   gcd ; git clean -d ; end
function   gcm ; git commit -m $argv ; end
function   gco ; git checkout $argv; end
function  gcob ; git checkout -b $argv ; end
function  gcom ; git checkout master ; end
function   gcp ; git cherry-pick $argv ; end
function   gcr ; git commit --reuse-message=HEAD --amend ; end
function    gd ; git pull $argv ; end
function   gdu ; git pull ; and git push ; end
function  gdts ; git stash; git pull; git stash pop ; end
function    gf ; git diff $argv ; end
function   gfc ; git diff --cached $argv ; end
function    gl ; git log $argv ; end
function   glp ; git log -p $argv ; end
function  glpr ; git log -p --reverse $argv ; end
function    gm ; git merge $argv ; end
function    gn ; git clone $argv ; end
function   grh ; git reset HEAD ; end
function   gri ; git rebase -i $argv ; end
function   grc ; git rebase --continue ; end
function    gs ; git stash $argv ; end
function   gsa ; git stash apply $argv ; end
function   gsd ; git stash drop $argv ; end
function   gsl ; git stash list ; end
function   gsp ; git stash pop ; end
function    gt ; git status -sb ; end
function    gu ; git push $argv ; end
function   gwc ; git whatchanged $argv ; end
function    gx ; open -a gitx . ; end
function    gr ; git reset HEAD ; end
function   gr1 ; git reset 'HEAD^' ; end
function   gr2 ; git reset 'HEAD^^' ; end
function   gro ; git reset $argv ; end
function   grh ; git reset --hard HEAD ; end
function  grh1 ; git reset --hard 'HEAD^' ; end
function  grh2 ; git reset --hard 'HEAD^^' ; end
function  grho ; git reset --hard $argv ; end
function gvsc ; git add . ; git commit -am 'Auto-commit with useless commit message' ; git pull ; git push ; end


# function gfl
#   set limit $argv[1]
#   [ x$limit = x ] && set limit 10
#   git rev-list --all --objects | sed -n (git rev-list --objects --all |
#     cut -f1 -d' ' | git cat-file --batch-check | grep blob |
#     sort -n -k3 | tail -n$limit | while read hash type size;
#     do
#         echo -n "-e s/$hash/$size/p ";
#     done) |
#   sort -n -k1
# }

# Rubygems
function mp ; gem push $argv ; end
function mi ; gem install --no-ri --no-rdoc $argv ; and reh ; end
function mir ; mi $argv ; and fc -e - ; end
function mu ; gem uninstall $argv ; end

function mibi ; gem install --no-ri --no-rdoc $argv and bundle ; end

######## rails/rake stuff ####################################################
function   rdm ; bundle exec rake db:migrate ; end
function  rdmr ; bundle exec rake db:migrate:redo $argv ; end
function  rdmd ; bundle exec rake db:migrate:down $argv ; end
function rdres ; bundle exec rake db:reset ; end
function rR ; rake routes ; end
function rRg ; rake routes | grep $argv ; end
function  xrs ; bundle exec rails server ; end
function  xrc ; bundle exec rails console ; end
function  xrg ; bundle exec rails generate ; end
function  xrr ; bundle exec rails runner $argv ; end
function xr ; bundle exec rake $argv ; end
function cpd ; cap production deploy ; end
function csd ; cap staging deploy ; end

function r ; ruby $argv ; end

function e ; vim $argv 2>/dev/null ; end

function gbt ; git branch --track $argv[1] origin/$argv[1] ; end

function u ; cd .. ; end
function uu ; cd ../.. ; end
function uuu ; cd ../../.. ; end
function uuuu ; cd ../../../.. ; end
function uuuuu ; cd ../../../../.. ; end
function uuuuuu ; cd ../../../../../.. ; end

function up ; while [ ! -d .git -a `pwd` != "/" ]; cd ".."; end ; end

function chx ; chmod +x $argv ; end

function a ; ack $argv ; end
function ai ; ack -i $argv ; end
function aa ; ack -a $argv ; end
function aai ; ack -ai $argv ; end
function g ; grep $argv ; end
function t ; tail $argv ; end
function h ; head $argv ; end
function L ; less $argv ; end
function l ; ls $argv ; end
function less ; /usr/bin/less -FXRS $argv ; end

function rt; rake test; end
function rtu; rake test:units; end
function rtf; rake test:functionals; end

function fdg ; find . | grep ; end

if mac
  function ls ;gls --color=auto -F $argv ; end
else
  function ls ; ls --color=auto -F $argv ; end
end

function df ; df -hT $argv ; end

# if linux; then
#   alias sx="startx"
#   alias tsl="tail -f /var/log/syslog"
# fi

set PATH /usr/local/Cellar/macvim/7.3-64/MacVim.app/Contents/MacOS $PATH
set PATH $HOME/bin $PATH
set PATH /usr/local/mysql/bin $PATH
set PATH /usr/texbin $PATH
set PATH $HOME/.rbenv/shims $PATH
set PATH $HOME/.rbenv/bin $PATH
set PATH /usr/local/go/bin $PATH
rbenv rehash >/dev/null ^&1

if mac
  eval (gdircolors -b ~/.LS_COLORS | grep -v export | sed 's/LS_COLORS=/set -x LS_COLORS /')
else
  eval (dircolors -b ~/.LS_COLORS | grep -v export | sed 's/LS_COLORS=/set -x LS_COLORS /')
end


