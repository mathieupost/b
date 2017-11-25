package main

import (
	"fmt"
	"os"
	"path"
	"strconv"
)

var (
	fgReset   = fgColor(0)
	fgBlack   = fgColor(30)
	fgRed     = fgColor(31)
	fgGreen   = fgColor(32)
	fgYellow  = fgColor(33)
	fgBlue    = fgColor(34)
	fgMagenta = fgColor(35)
	fgCyan    = fgColor(36)
	fgWhite   = fgColor(37)
)

func fgColor(color int) string {
	return fmt.Sprintf("%%{\x1b[%dm%%}", color)
}

const darmok = "%{\x1b[38;5;51m%}d%{\x1b[38;5;45m%}a%{\x1b[38;5;39m%}r%{\x1b[38;5;33m%}m%{\x1b[38;5;27m%}o%{\x1b[38;5;21m%}k"

func hostnameInfo() string {
	hn, err := os.Hostname()
	if err != nil {
		hn = "error"
	}
	switch hn[0:6] {
	case "darmok":
		return darmok + fgBlue + ":"
	default:
		return fgYellow + hn + ":"
	}
}

func pathInfo() string {
	cwd, err := os.Getwd()
	if err != nil {
		cwd = "error"
	}
	return path.Base(cwd)
}

func statusAndPrompt() string {
	if len(os.Args) < 2 {
		return fgRed + "?"
	}
	num, err := strconv.Atoi(os.Args[1])
	if err != nil {
		num = 0
	}
	if num == 0 {
		return ""
	}
	return fgRed + os.Args[1]
}

func mode() string {
	mode := fgCyan + ">"
	if len(os.Args) >= 3 {
		mode = os.Args[2]
	}
	if mode == "main" {
		mode = fgCyan + ">"
	}
	if mode == "opp" {
		mode = fgYellow + "<"
	}
	if mode == "vicmd" {
		mode = fgMagenta + "<"
	}
	return mode
}

func main() {
	fmt.Printf("%s%s %s%s%s%s ", fgBlue+pathInfo(), gitInfo(), statusAndPrompt(), mode(), fgReset, "%(1j.%j.)")
}
