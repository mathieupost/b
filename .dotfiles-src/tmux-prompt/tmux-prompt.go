package main

import (
	"fmt"
	"os"
	"path/filepath"
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
* CPU stats
* mem stats
* indicators for whether vpns are connected

Ref:
http://www.opensource.apple.com/source/IOKitUser/IOKitUser-294/ps.subproj/IOPSKeys.h
*/

const (
	Arrow1 = ""
	Arrow0 = ""
)

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

var (
	boringColor = nobold(241, 233)
	greenColor  = nobold(2, 233)
	yellowColor = nobold(3, 233)
	redColor    = nobold(1, 233)
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
	hn, err := os.Hostname()
	if err != nil {
		hn = "???"
	}

	loadAvgs, err := loadAvg()

	pers, _ := filepath.Glob(os.Getenv("HOME") + "/.mail/notify/p:INBOX/new/*")
	shop, _ := filepath.Glob(os.Getenv("HOME") + "/.mail/notify/s:INBOX/new/*")
	git, _ := filepath.Glob(os.Getenv("HOME") + "/.mail/notify/github/new/*")
	color := nobold(237, 233)
	if len(pers) > 0 || len(shop) > 0 || len(git) > 0 {
		color = nobold(1, 233)
	}
	mails := fmt.Sprintf("%s %d:%d:%d", color, len(pers), len(shop), len(git))

	stat, err := os.Stat(os.Getenv("HOME") + "/.mutt/mbsync.log")
	threshold := time.Now().Add(-3 * time.Minute)
	if err != nil || stat.ModTime().Before(threshold) {
		mails = fmt.Sprintf("%s ?", nobold(1, 233))
	}

	batt := fmt.Sprintf("%d", C.percentage())
	power := fmt.Sprintf("%0.1fW", float64(C.power())/1e6)

	u, s, _ := sampleCPU()

	secs := C.secondsOfBatteryRemaining()
	mins := int(secs / 60.0)
	battRem := fmt.Sprintf("%dm", mins)
	if secs == -2 {
		battRem = "⚡ "
	}
	if secs == -1 {
		battRem = "⏳ "
	}

	vpns := C.connected()
	chicagoColor := nobold(1, 252)
	ashburnColor := nobold(1, 252)
	if 0 < vpns&C.CHICAGO_CONNECTED {
		chicagoColor = nobold(2, 252)
	}
	if 0 < vpns&C.ASHBURN_CONNECTED {
		ashburnColor = nobold(2, 252)
	}
	vpnChunk := fmt.Sprintf("%sC%sA", chicagoColor, ashburnColor)

	fmt.Printf("%s",
		nobold(233, -1)+" "+
			Arrow1+nobold(247, 233)+" "+
			batt+"%"+
			" "+battRem+
			" "+power+
			nobold(241, 233)+" "+
			Arrow0+" "+
			fmt.Sprintf("%02d'%02d", int(u*100), int(s*100))+" "+
			displayLoadAvgs(loadAvgs)+
			nobold(241, 233)+" "+
			Arrow0+
			mails+

			nobold(236, 233)+" "+
			Arrow1+nobold(252, 236)+" "+
			time.Now().Format("Jan02 15:04")+
			nobold(252, 236)+" "+
			Arrow1+bold(16, 252)+" "+
			vpnChunk+" "+bold(16, 252)+
			hn+
			" ")
}
