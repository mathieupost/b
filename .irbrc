# -*- coding: utf-8; mode: ruby -*-

def ras
  require 'active_support/all'
end

def bm(times=1_000_000, &b)
  require 'benchmark'
  time = Benchmark.realtime {
    times.times(&b)
  }
  puts "total: #{time}; iterations: #{times}; average: #{time / times}"
end


require File.expand_path("~/.config/ruby/all")

require 'ap'

unless ENV['NO_PRY']
  require 'pry'
  pry
  exit 0
end
