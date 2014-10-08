#!/bin/sh
export PYTHONPATH=/lib/python2.7/site-packages
if [ ! -f "/Users/burke/NOMAIL" ]; then
  mv /Users/burke/.mutt/offlineimap.log /Users/burke/.mutt/offlineimap.log.1
  offlineimap > /Users/burke/.mutt/offlineimap.log 2>&1
  if [ ! $? -eq 0 ]; then
    /usr/local/bin/terminal-notifier \
      -title offlineimap \
      -group offlineimap \
      -message "Sync failed (touch ~/NOMAIL maybe?)" \
      -sender "com.apple.Mail"
  fi
fi
