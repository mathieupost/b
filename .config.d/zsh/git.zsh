if [[ -x `which git` ]]; then

  function find-dot-git () {
    while [ ! -d $(pwd)/.git ]; do
      cd ..
      if [[ $(pwd) == / ]] { return 1; }
    done
    echo $(pwd)/.git
  }

	function git-prompt() {
    gitdir=$(find-dot-git)
    if [[ $? == 0 ]] {
  	  branch=$(cat $gitdir/HEAD | sed 's/ref: refs\/heads\///')
  		if [[ $(git-nohub status --porcelain 2> /dev/null) == "" ]] { dirty_color=$fg[green] } else { dirty_color=$fg[magenta] }
      if [[ $branch == master ]]     { branch=✪ }
  		if [[ $gitdir == $HOME/.git ]] { branch=✖ }
      if [[ x$branch == x ]] { 
        branch=◻
        dirty_color=$fg[white] 
      } else {
        if [[ -f $gitdir/refs/stash ]] {
          stashpart="[S] "
        }
      }
      echo "%{$dirty_color%}$branch%{$reset_color%} $stashpart"
    }
	}

	function git-scoreboard () {
		  git log | grep Author | sort | uniq -ci | sort -r
	}

	function github-init () {
		  git config branch.$(git-branch-name).remote origin
		  git config branch.$(git-branch-name).merge refs/heads/$(git-branch-name)
	}
	
	function github-url () {
		  git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
	}
	
	# Seems to be the best OS X jump-to-github alias from http://tinyurl.com/2mtncf
	function ghg () {
		  open $(github-url)
	}
	
fi