package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"strconv"
	"strings"
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

func hostnameInfo() string {
	hn, err := os.Hostname()
	if err != nil {
		hn = "error"
	}
	switch hn[0:5] {
	case "burke":
		return fgBlue
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

func gitDir() (string, bool) {
	cpath, e := os.Getwd()
	if e != nil {
		return "", false
	}

	for {
		// TODO(burke): this is foiled by a file named `.git`
		stat, err := os.Stat(cpath + "/.git")
		if !os.IsNotExist(err) && stat.IsDir() {
			return cpath + "/.git", true
		}
		if cpath == "/" {
			return "", false
		}
		cpath = path.Dir(cpath)
	}

}

func gitInfo() string {
	gitDir, ok := gitDir()
	if !ok {
		return ""
	}
	cmd := exec.Command("git", "status", "--porcelain")
	o, e := cmd.Output()
	if e != nil {
		return e.Error()
	}

	color := fgGreen
	if len(o) > 0 {
		color = fgMagenta
	}

	o, e = ioutil.ReadFile(gitDir + "/HEAD")
	if e != nil {
		return " error"
	}
	ref := ""
	if string(o[0:16]) == "ref: refs/heads/" {
		ref = strings.TrimSpace(string(o[16:]))
	} else {
		ref = string(o[0:8])
	}

	if ref == "master" {
		ref = "*"
	}

	stashCount := 0

	if o, e = ioutil.ReadFile(gitDir + "/logs/refs/stash"); e == nil {
		stashCount = bytes.Count(o, []byte{'\n'})
	}

	stash := ""
	if stashCount > 0 {
		stash = fgWhite + strconv.Itoa(stashCount)
	}

	return " " + color + ref + stash
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
	mode := "?"
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
	fmt.Printf("%s%s%s %s%s%s ", hostnameInfo(), pathInfo(), gitInfo(), statusAndPrompt(), mode(), fgReset)
}
