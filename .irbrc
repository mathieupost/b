# -*- coding: utf-8; mode: ruby -*-

def encoding_of(s)
  Encoding.
    constants.
    map    { |e| Encoding.const_get(e) }.
    select { |k| Encoding === k }.
    map    { |k| s.dup.force_encoding(k) }.
    reject { |f| f.inspect == s.inspect }.
    map    { |f| [f.encoding.name, f.encode(Encoding::UTF_8)] rescue "failed" }.
    uniq
end
# >> encoding_of "\x80\x93"
# => [["UTF-16BE", "肓"], ["UTF-16LE", "鎀"]]


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
