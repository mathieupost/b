#!/bin/bash

(
  cd tmux-prompt
  make install clean
)

(
  cd shell-prompt
  make install clean
)

(
  cd hostname-fix
  make install clean
)
