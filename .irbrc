# -*- coding: utf-8; mode: ruby -*-

Dir[ENV['HOME']+'/lib/**/*.rb'].each do |file|
  require file
end

require 'rubygems'
if RUBY_VERSION == "1.9.1"
  begin
    require 'wirble'
    Wirble::init
    Wirble::colorize
  rescue 
    require 'irb/completion'
    require 'irb/ext/save_history'
  end
else 
  begin
    require 'utility_belt' # hope this works with 1.9.1 soon...
  rescue 
    require 'irb/completion'
    require 'irb/ext/save_history'
  end
end

# rvmp = `rvm-prompt`.chomp

# IRB.conf[:PROMPT][:CUSTOM] = {
#     :PROMPT_N => "#{rvmp} ▸ ",
#     :PROMPT_I => "#{rvmp} ▸ ",
#     :PROMPT_S => nil,
#     :PROMPT_C => "  ▸ ",
#     :RETURN => " ➝  %s\n"
# }

# IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 500


