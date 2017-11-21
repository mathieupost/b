package main

import (
	"encoding/binary"
	"errors"
	"os"
	"unsafe"
)

/*
#include <sys/sysctl.h>
#include <sys/types.h>
#include <stdio.h>
#include <mach/mach.h>
#include <mach/processor_info.h>
#include <mach/mach_host.h>

int sample(int *user, int *system, int *idle)
{
  kern_return_t kr;
  mach_msg_type_number_t count;
  host_cpu_load_info_data_t r_load;

  uint64_t totalSystemTime = 0, totalUserTime = 0, totalIdleTime = 0;

  count = HOST_CPU_LOAD_INFO_COUNT;
  kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (int *)&r_load, &count);
  if (kr != KERN_SUCCESS) {
    printf("oops: %s\n", mach_error_string(kr));
    return -1;
  }

  *system = r_load.cpu_ticks[CPU_STATE_SYSTEM];
  *user = r_load.cpu_ticks[CPU_STATE_USER] + r_load.cpu_ticks[CPU_STATE_NICE];
  *idle = r_load.cpu_ticks[CPU_STATE_IDLE];

	return 0;
}
*/
import "C"

const (
	cachePath = "/tmp/tmux-right-cpu-sample"
)

type cpuSample struct {
	user, system, idle uint64
}

func (c cpuSample) total() uint64        { return c.user + c.system + c.idle }
func (c cpuSample) userRatio() float64   { return float64(c.user) / float64(c.total()) }
func (c cpuSample) systemRatio() float64 { return float64(c.system) / float64(c.total()) }
func (c cpuSample) idleRatio() float64   { return float64(c.idle) / float64(c.total()) }

func (s *cpuSample) Dump() error {
	f, err := os.OpenFile(cachePath, os.O_CREATE|os.O_WRONLY, 0660)
	if err != nil {
		return err
	}
	buf := make([]byte, 24)
	binary.PutUvarint(buf, s.user)
	binary.PutUvarint(buf[8:], s.system)
	binary.PutUvarint(buf[16:], s.idle)
	f.Write(buf)
	return f.Close()
}

func (s *cpuSample) Load() (err error) {
	f, err := os.OpenFile(cachePath, os.O_RDONLY, 0660)
	if err != nil {
		return err
	}
	buf := make([]byte, 24)
	f.Read(buf)
	s.user, _ = binary.Uvarint(buf)
	s.system, _ = binary.Uvarint(buf[8:])
	s.idle, _ = binary.Uvarint(buf[16:])
	return f.Close()
}

func (s *cpuSample) Diff(o cpuSample) cpuSample {
	return cpuSample{
		user:   s.user - o.user,
		system: s.system - o.system,
		idle:   s.idle - o.idle,
	}
}

func (s *cpuSample) Generate() error {
	if 0 != C.sample(
		(*C.int)(unsafe.Pointer(&s.user)),
		(*C.int)(unsafe.Pointer(&s.system)),
		(*C.int)(unsafe.Pointer(&s.idle))) {
		return errors.New("failed to generate")
	}
	return nil
}

func sampleCPU() (float64, float64, float64) {
	var s1, s2 cpuSample
	s1.Load()
	s2.Generate()
	if err := s2.Dump(); err != nil {
		return 0, 0, 0
	}

	diff := s2.Diff(s1)
	ur := diff.userRatio()
	sr := diff.systemRatio()
	ir := diff.idleRatio()
	if ur < 0 {
		ur = -1
	}
	if sr < 0 {
		sr = -1
	}
	if ir < 0 {
		ir = -1
	}
	return ur, sr, ir
}
