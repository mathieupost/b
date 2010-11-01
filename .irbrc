# -*- coding: utf-8; mode: ruby -*-

require 'ap'

Dir[ENV['HOME']+'/lib/**/*.rb'].each do |file|
  require file
end

require 'rubygems'
if RUBY_VERSION == "1.9.1"
  begin
    require 'wirble'
    Wirble::init
    Wirble::colorize
  rescue StandardError, LoadError
    require 'irb/completion'
    require 'irb/ext/save_history'
  end
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

# IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 500


class Object

  def locate_method(meth)
    self.class.ancestors.select{|klass|klass.instance_methods.map(&:to_s).include?(meth.to_s)}
  end 
  
  def method_inheritance
    meths = methods
    table = { }
    self.class.ancestors.each do |klass|
      table[klass.name] = []
      meths.each do |meth|
        table[klass.name] << meths.delete(meth) if klass.instance_methods.include?(meth)
      end 
    end 
    table
  end 
  
end 
