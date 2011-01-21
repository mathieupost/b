# -*- coding: utf-8; mode: ruby -*-

require 'ap'

require 'rubygems'
if RUBY_VERSION == "1.9.1"
  begin
    require 'wirble'
    Wirble::init
    Wirble::colorize
  rescue StandardError, LoadError; end
else 
  begin
    require 'utility_belt' # hope this works with 1.9.1 soon...
  rescue LoadError
    begin
      require 'irb/completion'
      require 'irb/ext/save_history'
    rescue LoadError; end 
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

class Object
  def gm(sym)
    __goto_method(method(sym))
  end 
  def gim(sym)
    __goto_method(instance_method(sym))
  end 
  def __goto_method(x)
    system("$EDITOR -n '+#{x.__line__}' \"#{x.__file__}\"")
  end 
end 

# IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000

require File.expand_path("~/.config.d/ruby/all")

require 'bond'
Bond.start


