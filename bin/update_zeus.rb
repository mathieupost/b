require 'rubygems'

arch = case `uname -sm`
       when /^Darwin/ ; "darwin-amd64"
       when /^Linux.*64/ ; "linux-amd64"
       when /^Linux/ ; "linux-386"
       end

bin_path = Gem.bin_path('zeus', 'zeus')
gem_path = File.expand_path "../../", bin_path
executable_path = File.expand_path "build/zeus-#{arch}", gem_path

script = <<SH
#!/bin/sh
#{executable_path} $*
SH

puts script
