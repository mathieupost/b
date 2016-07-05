package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"time"
)

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework CoreFoundation -framework IOKit
extern int power(void);
extern int percentage(void);
extern double secondsOfBatteryRemaining(void);
extern int CHICAGO_CONNECTED;
extern int ASHBURN_CONNECTED;
extern int connected(void);
*/
import "C"

/*

TODO:
* Colourize battery based on percentage
* Show time to full charge or complete discharge
* Colorize something based on whether plugged in or not
* More colour gradients for load averages
* mem stats

Ref:
http://www.opensource.apple.com/source/IOKitUser/IOKitUser-294/ps.subproj/IOPSKeys.h
*/

const (
	Arrow1 = ""
	Arrow0 = ""
)

func init() {
	println("wtf")
}

var superscripts = []string{"⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"}

func bold(fg, bg int) string {
	return color(fg, bg, true)
}

func nobold(fg, bg int) string {
	return color(fg, bg, false)
}

func color(fg, bg int, bold bool) string {
	bgc := "default"
	if bg >= 0 {
		bgc = fmt.Sprintf("colour%d", bg)
	}
	bt := "bold"
	if !bold {
		bt = "nobold"
	}
	return fmt.Sprintf("#[fg=colour%d,bg=%s,%s,noitalics,nounderscore]", fg, bgc, bt)
}

// black is 232, white is 255
const (
	timeBG     = 242
	hostnameBG = 7
	hostnameFG = 16
	otherBG    = 238
	noMailFG   = 246
)

var (
	boringColor = nobold(noMailFG, otherBG)
	greenColor  = nobold(2, otherBG)
	yellowColor = nobold(3, otherBG)
	redColor    = nobold(1, otherBG)
)

func displayLoadAvgs(loadAvgs [3]float64) string {

	var parts []string

	for _, avg := range loadAvgs {
		whole := int(avg)
		frac := int((avg - float64(whole)) * 10)
		color := boringColor
		if avg > 2.0 {
			color = yellowColor
		}
		if avg > 3.0 {
			color = redColor
		}
		parts = append(parts, fmt.Sprintf("%s%d%s", color, whole, superscripts[frac]))
	}

	return strings.Join(parts, "")
}

func main() {
	t1 := time.Now()
	hn, err := os.Hostname()
	if err != nil {
		hn = "???"
	}
	println("a")

	loadAvgs, err := loadAvg()
	t2 := time.Now()

	println("a")
	home := os.Getenv("HOME")
	pers, _ := ioutil.ReadDir(home + "/.mail/notify/p:INBOX/new")
	shop, _ := ioutil.ReadDir(home + "/.mail/notify/s:INBOX/new")
	git, _ := ioutil.ReadDir(home + "/.mail/notify/github/new")
	color := nobold(noMailFG, otherBG)
	if len(pers) > 0 || len(shop) > 0 || len(git) > 0 {
		color = nobold(1, otherBG)
	}
	mails := fmt.Sprintf("%s %d:%d:%d", color, len(pers), len(shop), len(git))

	println("a")
	stat, err := os.Stat(home + "/.mutt/mbsync.log")
	threshold := time.Now().Add(-3 * time.Minute)
	if err != nil || stat.ModTime().Before(threshold) {
		mails = fmt.Sprintf("%s ?", nobold(1, otherBG))
	}
	t3 := time.Now()

	batt := fmt.Sprintf("%d", C.percentage())
	power := fmt.Sprintf("%0.1fW", float64(C.power())/1e6)

	println("a")
	u, s, _ := sampleCPU()

	t4 := time.Now()
	secs := C.secondsOfBatteryRemaining()
	mins := int(secs / 60.0)
	battRem := fmt.Sprintf("%dm", mins)
	if secs == -2 {
		battRem = "⚡ "
	}
	if secs == -1 {
		battRem = "⏳ "
	}
	println("a")

	t5 := time.Now()
	vpns := C.connected()
	chicagoColor := nobold(1, hostnameBG)
	ashburnColor := nobold(1, hostnameBG)
	if 0 < vpns&C.CHICAGO_CONNECTED {
		chicagoColor = nobold(2, hostnameBG)
	}
	if 0 < vpns&C.ASHBURN_CONNECTED {
		ashburnColor = nobold(2, hostnameBG)
	}
	vpnChunk := fmt.Sprintf("%sC%sA", chicagoColor, ashburnColor)
	t6 := time.Now()

	println("a")
	fmt.Printf("%s",
		nobold(otherBG, -1)+" "+
			Arrow1+nobold(247, otherBG)+" "+
			batt+"%"+
			" "+battRem+
			" "+power+
			boringColor+" "+
			Arrow0+" "+
			fmt.Sprintf("%02d'%02d", int(u*100), int(s*100))+" "+
			displayLoadAvgs(loadAvgs)+
			boringColor+" "+
			Arrow0+
			mails+

			nobold(timeBG, otherBG)+" "+
			Arrow1+nobold(hostnameBG, timeBG)+" "+
			time.Now().Format("Jan02 15:04")+
			nobold(hostnameBG, timeBG)+" "+
			Arrow1+bold(hostnameFG, hostnameBG)+" "+
			vpnChunk+" "+bold(hostnameFG, hostnameBG)+
			hn+
			" ")
	t7 := time.Now()

	println("a")
	_ = t1
	_ = t2
	_ = t3
	_ = t4
	_ = t5
	_ = t6
	_ = t7

	/*
		total := float64(t7.Sub(t1).Nanoseconds())
		fmt.Println(float64(t2.Sub(t1).Nanoseconds()) / total)
		fmt.Println(float64(t3.Sub(t2).Nanoseconds()) / total)
		fmt.Println(float64(t4.Sub(t3).Nanoseconds()) / total)
		fmt.Println(float64(t5.Sub(t4).Nanoseconds()) / total)
		fmt.Println(float64(t6.Sub(t5).Nanoseconds()) / total)
		fmt.Println(float64(t7.Sub(t6).Nanoseconds()) / total)
	*/

}
