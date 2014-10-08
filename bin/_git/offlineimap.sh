#!/bin/bash

export PYTHONPATH=/lib/python2.7/site-packages
export PATH="/usr/local/bin:${PATH}"

PID="$(cat ~/.offlineimap/pid)"
ps aux | grep "[ ]${PID}" && kill "${PID}"

opts="-q"
if [[ "$(jot -r 1 1 10)" = "10" ]] ; then # 90% chance
  opts=""
fi

if [ ! -f "/Users/burke/NOMAIL" ]; then
  mv /Users/burke/.mutt/offlineimap.log /Users/burke/.mutt/offlineimap.log.1
  offlineimap ${opts} 2>&1 | ts > /Users/burke/.mutt/offlineimap.log
  if [ $? -ne 0 ]; then
    terminal-notifier \
      -title offlineimap \
      -group offlineimap \
      -message "Sync failed (touch ~/NOMAIL maybe?)" \
      -sender "com.apple.Mail"
  fi
fi
