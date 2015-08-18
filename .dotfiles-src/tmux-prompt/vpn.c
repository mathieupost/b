#include <ifaddrs.h>
#include <arpa/inet.h>
#include <string.h>

const uint8_t chicago_addr[14] = {0,0,10,10,29,46,0,0,0,0,0,0,0,0};
const uint8_t ashburn_addr[14] = {0,0,10,20,28,54,0,0,0,0,0,0,0,0};

const int CHICAGO_CONNECTED = 1 << 0;
const int ASHBURN_CONNECTED = 1 << 1;

int connected() {
  struct ifaddrs *interfaces;
  struct ifaddrs *iface;
  struct sockaddr *sa;

  int connected = 0;

  if (0 != getifaddrs(&interfaces)) {
    return 0;
  }

  for (iface = interfaces; 0 != iface; iface = iface->ifa_next) {
    sa = iface->ifa_addr;
    if (sa->sa_family == AF_INET) {
      if (0 == memcmp(sa->sa_data, chicago_addr, 14)) {
        connected |= CHICAGO_CONNECTED;
      }
      if (0 == memcmp(sa->sa_data, ashburn_addr, 14)) {
        connected |= ASHBURN_CONNECTED;
      }
    }
  }

  freeifaddrs(interfaces);

  return connected;
}
