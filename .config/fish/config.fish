function fish_prompt ; ~/src/github.com/burke/wunderprompt/prompt $status ; end

set fish_greeting ''

function mac ; test (uname -s) = "Darwin" ; end
function linux ; test (uname -s) = "Linux" ; end

set -x MANTA_URL https://us-east.manta.joyent.com
set -x MANTA_USER shopify
set -x MANTA_KEY_ID 00:38:be:b9:e5:54:ea:66:6f:ed:af:5e:d6:6c:3a:8d

function vup; vagrant up ; end
function vhalt; vagrant halt ; end
function vdestroy; vagrant destroy -f ; end
function vssh; vagrant ssh ; end
function vprov; vagrant provision ; end

function mutt
  bash --login -c 'cd ~/Desktop; /usr/local/bin/mutt' $argv;
end

set -x PYTHONPATH /lib/python2.7/site-packages


function vagrant-list-running;  ps aux | grep -i [v]mware-vmx | grep -oE '([^/]+)/.vagrant' | cut -d/ -f1 ; end

function ke ; knife node edit $argv[1].chi.shopify.com ; end

function bmd
  ruby -ne "puts \$_.sub(/(?<=version          ')([\d\.]+)(?=')/){|f|a=\$1.split('.').map(&:to_i);a[-1]+=1;a.join('.')}" < $argv[1]/metadata.rb | sponge > $argv[1]/metadata.rb
  git add $argv[1]/metadata.rb
  git commit -m "bump metadata"
end

function cdep; bundle exec cap deploy; end

set -x CDPATH . $HOME/src/github.com $HOME/src/github.com/burke $HOME/src/github.com/Shopify $HOME/src/hobos
set -x EDITOR vim

set -x GOPATH $HOME
set -x PATH $GOPATH/bin $PATH
set -x PATH $HOME/src/go/bin $PATH

set -x RUBY_GC_MALLOC_LIMIT 1000000000
set -x RUBY_GC_HEAP_SLOTS_FREE 500000
set -x RUBY_GC_HEAP_INIT_SLOTS 40000

function tmux
  set TERM screen-256color-bce
  /usr/bin/env tmux $argv
end

function gh ; cd (_gh $argv) ; end
function ghs ; cd (_gh Shopify $argv) ; end

function c1c ; cut -c1-$COLUMNS ; end

function def          ; ack "def $argv" ; end
function reh          ; rbenv rehash    ; end

function shop         ; gh Shopify shopify ; end
function to           ; script/testonly $argv ; end

function xrgm         ; e (bundle exec rails generate migration $argv[1] | tail -n1 | awk '{print $3}') ; end
function elm          ; e db/migrate/(ls db/migrate | tail -n1) ; end


function gc ; if test $argv[1] ; git commit -a -m "$argv" ; else ; git commit -a -v ; end ; end

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

function sch ; ssh $argv[1].chi ; end

function vcc; osascript -e 'tell application "Viscosity" to connectall' ; end
function vcdc; osascript -e 'tell application "Viscosity" to disconnectall' ; end

function cros_sdk; cd ~/src/coreos ; vagrant ssh -c "coreos/chromite/bin/cros_sdk" ; or sh -c 'vagrant up && vagrant ssh -c coreos/chromite/bin/cros_sdk' ; end



function Sgb; git branch --list | grep -v '^\*' | selecta | xargs git checkout ; end

######## bundler #############################################################
function bi ; bundle install ; end
function bo ; bundle open $argv ; end
function bu ; bundle update $argv ; end
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

function gl
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative $argv
end


function lol
  set HASH "%C(yellow)%h%Creset"
  set RELATIVE_TIME "%Cgreen(%ar)%Creset"
  set AUTHOR "%C(blue)<%an>%Creset"
  set REFS "%C(red)%d%Creset"
  set SUBJECT "%s"

  set FORMAT "$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"

  git log -200 --pretty="format:$FORMAT" $argv | sed -Ee 's/(^[^<]*) ago)/\1)/' | sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?)/\1)/' | column -s '}' -t | less -FXRS
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
function gfrom ; gfro master ; end
function gfrog ; gfro (gb | g '*' | ap2) ; end
function  gfro ; gfr origin $argv ; end
function   gfr ; git fetch $argv ; and git reset --hard FETCH_HEAD ; end
function   gac ; gc $argv ; end
function   gap ; git add -p $argv ; end
function   gav ; git commit -av $argv ; end
function    gb ; git branch $argv; end
function   gbl ; git branch -l $argv; end
function   gug ; guo (gb | g '*' | ap2) ; end
function    gu ; git push $argv ; end
function   guo ; git push origin $argv ; end
function   gfd ; git fetch origin (gb | g '*' | ap2) ; and git reset --hard FETCH_HEAD ; end
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


function ghg ; open https://github.com/$argv ; end
function ghgb ; ghg burke/$argv ; end
function ghgs ; ghg shopify/$argv ; end

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
function   rft ; rake fast:test ; end
function  rdtp ; rake db:test:prepare ; end
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
function xrt ; bundle exec rake test $argv ; end
function cpd ; cap production deploy ; end
function csd ; cap staging deploy ; end
function zs ; zeus server ; end
function zc ; zeus console ; end
function zr ; zeus rake ; end

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

function tunsc ; sshuttle -vr util1 172.16.0.0/16 172.17.0.0/16 ; end

function vgs ; cd ~/src/s/vagrant ; and vagrant ssh ; end

if mac
  function ls ;gls --color=auto -F $argv ; end
else
  function ls ; ls --color=auto -F $argv ; end
end

function df ; df -hT $argv ; end

function =; nextd ; end
function -; prevd ; end

function ssh-add
  eval (ssh-agent | head -2 | sed -e 's/^\\([^=]*\\)=\\([^;]*\\);.*/set -x \\1 \\2;/')
  /usr/bin/ssh-add $argv
end

set -x PYTHONPATH $PYTHONPATH /Users/burke/.config/powerline

set -x PATH /Users/burke/src/chromium.googlesource.com/chromium/tools/depot_tools $PATH
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/texbin $PATH
set -x PATH /Users/burke/src/code.google.com/p/go/bin $PATH
set -x PATH $HOME/bin $PATH
set -x PATH $HOME/bin/_git $PATH

if mac
  set -x PATH /usr/local/Cellar/macvim/7.4-71/MacVim.app/Contents/MacOS $PATH
else
  set -x PATH $HOME/.rbenv/bin $PATH
  set -x PATH $HOME/.rbenv/shims $PATH
end

if mac
  . ~/.config/fish/boxen.fish
  eval (gdircolors -b ~/.LS_COLORS | grep -v export | sed 's/LS_COLORS=/set -x LS_COLORS /')
else
  set -x CONCURRENCY_LEVEL 7
  rbenv rehash > /dev/null ^/dev/null
  eval (dircolors -b ~/.LS_COLORS | grep -v export | sed 's/LS_COLORS=/set -x LS_COLORS /')
end

set -e MANPATH

set -x PATH ~/.rbenv/shims ~/.rbenv/bin $PATH
rbenv rehash 2>/dev/null
