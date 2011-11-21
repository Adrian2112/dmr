class Object
  
  def to_boolean
     if self.is_a?(TrueClass) || self.is_a?(FalseClass)
      return self
    else
      return false
    end    
  end
end