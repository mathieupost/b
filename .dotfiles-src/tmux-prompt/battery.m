#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>

#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>

#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/pwr_mgt/IOPM.h>

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

  return (int)(100 * ((double)currentCapacity / (double)maxCapacity));
}

// For some reason kIOPSVoltageKey isn't working if I try to use the 
// IOPowerSources API, but IOKit's PowerManagement lib works just fine.
int power(void) {
  mach_port_t     port;
  kern_return_t   kr;
  CFArrayRef      battery_infos;
  CFDictionaryRef info;
  CFNumberRef     value;
  int current, voltage;

  kr = IOMasterPort(bootstrap_port, &port);
  if (kr != kIOReturnSuccess) {
    return 0;
  }

  kr = IOPMCopyBatteryInfo(port, &battery_infos);
  if (kr != kIOReturnSuccess) {
    return 0;
  }

  info = (CFDictionaryRef)CFArrayGetValueAtIndex(battery_infos, 0);

  value = (CFNumberRef)CFDictionaryGetValue(info, CFSTR(kIOBatteryVoltageKey));
  CFNumberGetValue(value, kCFNumberSInt32Type, &voltage);

  value = (CFNumberRef)CFDictionaryGetValue(info, CFSTR(kIOBatteryAmperageKey));
  CFNumberGetValue(value, kCFNumberSInt32Type, &current);

  return voltage * current;
}
