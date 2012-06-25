# -*- coding: utf-8; mode: ruby -*-

def ras
  require 'active_support/all'
end
require File.expand_path("~/.config/ruby/all")

require 'ap'

unless ENV['NO_PRY']
  require 'pry'
  pry
  exit 0
end
