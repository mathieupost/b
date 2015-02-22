package main

import (
	"fmt"
	"os"
	"path/filepath"
	"time"
)

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework CoreFoundation -framework IOKit
#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>

double secondsOfBatteryRemaining(void) {
  return IOPSGetTimeRemainingEstimate();
}

int percentage(void) {
  CFTypeRef info, member;
  CFArrayRef arr;
  CFDictionaryRef dict;
  CFNumberRef value;
  int maxCapacity, currentCapacity;
  float perc;

  if (NULL == (info = IOPSCopyPowerSourcesInfo())) {
    return -1;
  }
  if (NULL == (arr = IOPSCopyPowerSourcesList(info))) {
    return -2;
  }

  if (NULL == (member = (CFTypeRef)CFArrayGetValueAtIndex(arr, 0))) {
    return -3;
  }
  if (NULL == (dict = IOPSGetPowerSourceDescription(info, member))) {
    return -4;
  }

  value = (CFNumberRef)CFDictionaryGetValue(dict, CFSTR(kIOPSMaxCapacityKey));
  CFNumberGetValue(value, kCFNumberSInt32Type, &maxCapacity);

  value = (CFNumberRef)CFDictionaryGetValue(dict, CFSTR(kIOPSCurrentCapacityKey));
  CFNumberGetValue(value, kCFNumberSInt32Type, &currentCapacity);

  CFRelease(member);
  CFRelease(arr);
  CFRelease(info);

  return (int)(100 * ((double)currentCapacity / (double)maxCapacity));
}

*/
import "C"

const (
	Arrow1 = ""
	Arrow0 = ""
)

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

func main() {
	hn, err := os.Hostname()
	if err != nil {
		hn = "???"
	}

	uptimes, err := loadAvg()

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

	fmt.Printf("%s",
		nobold(233, -1)+" "+
			Arrow1+nobold(247, 233)+" "+
			batt+"%"+
			nobold(241, 233)+" "+
			Arrow0+nobold(2, 233)+" "+
			fmt.Sprintf("%0.1f ", uptimes[0])+
			nobold(2, 233)+
			fmt.Sprintf("%0.1f ", uptimes[1])+
			nobold(2, 233)+
			fmt.Sprintf("%0.1f", uptimes[2])+

			nobold(241, 233)+" "+
			Arrow0+
			mails+

			nobold(236, 233)+" "+
			Arrow1+nobold(252, 236)+" "+
			time.Now().Format("2006-01-02 15:04")+
			nobold(252, 236)+" "+
			Arrow1+bold(16, 252)+" "+
			hn+
			" ")
}