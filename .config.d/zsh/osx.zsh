set_term_bgcolor() {
   local R=$1
   local G=$2
   local B=$3
   /usr/bin/osascript <<EOF
tell application "Terminal"
   tell window 0
      set the background color to {$(($R*65535/255)), $(($G*65535/255)), $(($B*65535/255))}
   end tell
end tell
EOF
}

with_terminal_color() {
  set_term_bgcolor $1 $2 $3
  shift;shift;shift

  $@

  set_term_bgcolor 0 0 0  
}

ssh() {
  if [[ "$@" =~ panda-build ]]; then
    set_term_bgcolor 0 0 31
  elif [[ "$@" =~ panda-staging ]]; then
    set_term_bgcolor 0 31 0
  elif [[ "$@" =~ og ]]; then
    set_term_bgcolor 0 31 31
  fi

  /usr/bin/ssh $@

  set_term_bgcolor 0 0 0
}