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

int current(void) {
  CFTypeRef info, member;
  CFArrayRef arr;
  CFDictionaryRef dict;
  CFNumberRef value;
  int current;

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

  value = (CFNumberRef)CFDictionaryGetValue(dict, CFSTR(kIOPSCurrentKey));
  CFNumberGetValue(value, kCFNumberSInt32Type, &current);

  CFRelease(member);
  CFRelease(arr);
  CFRelease(info);

  return current;
}
