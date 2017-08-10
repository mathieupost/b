#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int
main()
{
  int ret = execl("/usr/sbin/scutil", "/usr/sbin/scutil", "--set", "HostName", "darmok.local", NULL);
  printf("%d:%d\n", ret, errno);
}
