function git-scoreboard () {
  git log | grep Author | sort | uniq -ci | sort -r
}

function github-url () {
  git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
}

function ghg () {
  open $(github-url)
}
