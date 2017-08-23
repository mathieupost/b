#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int
main()
{
  pid_t pid;
  int stat;

  pid = fork();
  if (pid == 0) {
     return execl("/usr/sbin/scutil", "/usr/sbin/scutil", "--set", "HostName", "darmok.local", NULL);
  }

  waitpid(pid, &stat, 0);
  return execl("/usr/sbin/scutil", "/usr/sbin/scutil", "--set", "LocalHostName", "darmok", NULL);
}
