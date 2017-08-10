#include <unistd.h>

int
main()
{
  return execl("/usr/sbin/scutil", "/usr/sbin/scutil", "--set", "HostName", "darmok.local", NULL);
}
