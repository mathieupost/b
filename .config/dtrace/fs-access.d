#pragma D option dynvarsize=32M
#pragma D option switchrate=1msec
#pragma D option bufsize=25m
#pragma D option quiet

syscall::open:entry            /pid == $target/ { self->path = arg0; }
syscall::shm_open:entry        /pid == $target/ { self->path = arg0; }
syscall::open_extended:entry   /pid == $target/ { self->path = arg0; }
syscall::accept:entry          /pid == $target/ { self->fd   = arg0; }
syscall::accept_nocancel:entry /pid == $target/ { self->fd   = arg0; }
syscall::dup:entry             /pid == $target/ { self->fd   = arg0; }

syscall::open:return            /pid == $target              / { p[pid, arg1] = copyinstr(self->path); printf("%s\t%s\n", probefunc, p[pid, arg1]); }
syscall::shm_open:return        /pid == $target              / { p[pid, arg1] = copyinstr(self->path); printf("%s\t%s\n", probefunc, p[pid, arg1]); }
syscall::open_extended:return   /pid == $target              / { p[pid, arg1] = copyinstr(self->path); printf("%s\t%s\n", probefunc, p[pid, arg1]); }
syscall::accept:return          /pid == $target && arg0 != -1/ { p[pid, arg0] = p[pid, self->fd];      printf("%s\t%s\n", probefunc, p[pid, arg0]); }
syscall::accept_nocancel:return /pid == $target && arg0 != -1/ { p[pid, arg0] = p[pid, self->fd];      printf("%s\t%s\n", probefunc, p[pid, arg0]); }
syscall::dup:return             /pid == $target              / { p[pid, arg0] = p[pid, self->fd];      printf("%s\t%s\n", probefunc, p[pid, arg0]); }
syscall::dup2:entry             /pid == $target && arg0 != -1/ { p[pid, arg1] = p[pid, arg0];          printf("%s\t%s\n", probefunc, p[pid, arg0]); }
syscall::socket:return          /pid == $target && arg0 != -1/ { p[pid, arg0] = "socket";              printf("%s\t%s\n", probefunc, p[pid, arg0]); }

syscall::close:entry /pid == $target/ {
  closedpaths[pid, arg0] = p[pid, arg0];
  p[pid, arg0] = 0;
  printf("%s\t%s\n", probefunc, closedpaths[pid, arg0]);
}

syscall::mount:entry           /pid == $target/ { printf("%s\t%s\t%s\n", probefunc, copyinstr(arg0), copyinstr(arg1) ); }
syscall::rename:entry          /pid == $target/ { printf("%s\t%s\t%s\n", probefunc, copyinstr(arg0), copyinstr(arg1) ); }
syscall::symlink:entry         /pid == $target/ { printf("%s\t%s\t%s\n", probefunc, copyinstr(arg0), copyinstr(arg1) ); }
syscall::link:entry            /pid == $target/ { printf("%s\t%s\t%s\n", probefunc, copyinstr(arg0), copyinstr(arg1) ); }
syscall::unmount:entry         /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::delete:entry          /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::rmdir:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::mkdir:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::unlink:entry          /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::stat:entry            /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::stat64:entry          /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::lstat:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::lstat64:entry         /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::chmod:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::chown:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::chmod_extended:entry  /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::mkdir_extended:entry  /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::getxattr:entry        /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::setxattr:entry        /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::listxattr:entry       /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::removexattr:entry     /pid == $target/ { printf("%s\t%s\n",     probefunc, copyinstr(arg0)                  ); }
syscall::fstat:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fstat_extended:entry  /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fstat64:entry         /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::read:entry            /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::pread:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::write:entry           /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::pwrite:entry          /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fchmod:entry          /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fchown:entry          /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fchmod_extended:entry /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fgetxattr:entry       /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fsetxattr:entry       /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::flistxattr:entry      /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
syscall::fremovexattr:entry    /pid == $target/ { printf("%s\t%s\n",     probefunc, p[pid, arg0]                     ); }
