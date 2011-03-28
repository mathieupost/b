class Object
  def m
    (self.methods-self.class.methods).sort
  end
end

