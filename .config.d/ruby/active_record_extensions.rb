# https://github.com/gmarik/dotfiles/blob/master/.ruby/lib/gmarik/activerecord_ext.rb

if defined?(::ActiveRecord)
  module ActiveRecord
    class Base
      class << self
        def first
          find(:first, *args); 
        end unless method_defined?(:first)
 
        def last
          find(:first, :order => 'id DESC' ); 
        end unless method_defined?(:last)
 
        alias  :[] :find unless method_defined?(:[])
        alias  :f  :first
        alias  :l  :last 
      end
    end
  end 
end 

# .irbrc is loaded before Rails in s/c. TODO figure out how to make this file work properly.

#if defined?(::ActiveRecord)
  def DB!(db_env)
    ActiveRecord::Base.establish_connection(db_env)
  end

  def SQL(sql)
    ActiveRecord::Base.connection.select_all(sql)
  end

  def log!(stream = $stdout) 
    ActiveRecord::Base.logger = Logger.new(stream)
    ActiveRecord::Base.clear_reloadable_connections!
  end

  def nolog!; log!(nil); end
#end

