package main

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

func main() {
	es, err := filepath.Glob("/dev/cu.usbmodemCkbio*")
	ckerr(err)

	ser, err := StartSerial(es[0])
	ckerr(err)

	for i := 1; i <= 7; i++ {
		data := getdata(i)
		fmt.Printf("alert %d %d\n", i, data)
		ckerr(ser.Send(fmt.Sprintf("alert %d %d\n", i, data)))
		time.Sleep(30 * time.Millisecond)
	}
}

func getdata(n int) int {
	data, err := ioutil.ReadFile(fmt.Sprintf("/tmp/kbd-data/%d", n))
	if err != nil {
		return 0
	}
	i, err := strconv.ParseInt(strings.TrimSpace(string(data)), 10, 64)
	if err != nil {
		return 0
	}
	if i > 255 {
		return 0
	}
	return int(i)
}

func ckerr(err error) {
	if err != nil {
		panic(err)
	}
}
