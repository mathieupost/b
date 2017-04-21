package main

import (
	"bytes"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"strconv"
	"strings"
)

func gitDir() (string, bool) {
	cpath, e := os.Getwd()
	if e != nil {
		return "", false
	}

	for {
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

	pending := ""
	if _, err := os.Stat(ditDir + "/rebase-merge"); err == nil {
		pending = "{R}"
	} else if _, err := os.Stat(ditDir + "/CHERRY_PICK_HEAD"); err == nil {
		pending = "{C}"
	} else if _, err := os.Stat(ditDir + "/MERGE_HEAD"); err == nil {
		pending = "{M}"
	}

	return " " + color + ref + stash + pending
}
