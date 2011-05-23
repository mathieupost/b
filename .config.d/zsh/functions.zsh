mdc()    { mkdir -p "$1" && cd "$1" }
setenv() { export $1=$2 }
sdate()  { date +%Y.%m.%d }
pc()     { awk "{print \$$1}" }

turbo()  {
  if [[ $RUBY_HEAP_MIN_SLOTS == 1000000 ]] {
    unset RUBY_HEAP_MIN_SLOTS
    unset RUBY_HEAP_SLOTS_INCREMENT
    unset RUBY_HEAP_SLOTS_GROWTH_FACTOR
    unset RUBY_GC_MALLOC_LIMIT
    unset RUBY_HEAP_FREE_MIN
  } else {
    export RUBY_HEAP_MIN_SLOTS=1000000
    export RUBY_HEAP_SLOTS_INCREMENT=1000000
    export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
    export RUBY_GC_MALLOC_LIMIT=1000000000
    export RUBY_HEAP_FREE_MIN=500000
  }
}

function powCycle {
  echo "*** Stopping the Pow server..."
  launchctl unload -F "$HOME/Library/LaunchAgents/cx.pow.powd.plist" || true
  echo "*** Starting the Pow server..."
  launchctl load -F "$HOME/Library/LaunchAgents/cx.pow.powd.plist"
}

function powOff {
  sudo launchctl unload /Library/LaunchDaemons/cx.pow.firewall.plist
  sudo ipfw flush
}

function powOn {
  sudo launchctl load /Library/LaunchDaemons/cx.pow.firewall.plist
}

