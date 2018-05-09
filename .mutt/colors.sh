#!/bin/bash

touch /tmp/neato-1234

if [[ "${TERM_BG}" == "light" ]]; then
  echo "source /Users/burke/.mutt/mutt-colors-solarized-light-16.muttrc"
else
  echo "source /Users/burke/.mutt/mutt-colors-solarized-dark-16.muttrc"
fi
