function rusterr
  set num (printf "%04d" $argv[1])
  open "https://doc.rust-lang.org/error-index.html#E"$num
end

