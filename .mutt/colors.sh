#!/bin/bash

if [[ "${TERM_BG}" == "light" ]]; then
  echo "source /Users/burke/.mutt/base16-gruvbox.light.256.muttrc"
else
  # echo "source /Users/burke/.mutt/base16-gruvbox.dark.256.muttrc"
  echo "source /Users/burke/.mutt/gruvbox-256"
fi
