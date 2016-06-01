package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
	"sync"
)

const root = "/Users/burke/src/github.com/Shopify"
const concurrency = 20

func main() {
	f, err := os.Open(root)
	if err != nil {
		panic(err)
	}
	names, err := f.Readdirnames(0)
	if err != nil {
		panic(err)
	}

	repos := make(chan string)

	var wg sync.WaitGroup
	wg.Add(concurrency)
	for i := 0; i < concurrency; i++ {
		go func() {
			defer wg.Done()
			for repo := range repos {

				branch, err := headBranch(repo)
				if err != nil {
					fmt.Printf("\x1b[31m✗\x1b[0m %s\n", repo)
					continue
				}

				cmd := exec.Command(
					"/usr/local/bin/git",
					"-C", fmt.Sprintf("%s/%s", root, repo),
					"pull", "origin", branch)
				err = cmd.Run()
				if err != nil {
					fmt.Printf("\x1b[31m✗\x1b[0m %s\n", repo)
				} else {
					fmt.Printf("\x1b[32m✓\x1b[0m %s\n", repo)
				}
			}
		}()
	}

	for _, name := range names {
		if _, err := os.Stat(fmt.Sprintf("%s/%s/.git", root, name)); err == nil {
			repos <- name
		}
	}
	close(repos)

	wg.Wait()
}

func headBranch(repo string) (string, error) {
	cacheFile := fmt.Sprintf("%s/%s/.git/head-branch", root, repo)
	data, err := ioutil.ReadFile(cacheFile)
	if err == nil {
		return strings.TrimSpace(string(data)), nil
	}
	cmd := exec.Command(
		"/bin/bash",
		"-c",
		fmt.Sprintf("git -C %s/%s remote show origin | awk '/HEAD branch/ { print $3 }'", root, repo))
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	if err := ioutil.WriteFile(cacheFile, out, 0660); err != nil {
		return "", err
	}
	return strings.TrimSpace(string(out)), nil
}
