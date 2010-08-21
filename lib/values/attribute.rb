
class Attribute
  attr_reader :name,:type
  
  def initialize name_or_hash,type = nil
    name = nil
    if name_or_hash.is_a? Hash
      name = name_or_hash[:name]
      type = name_or_hash[:type]
    else
      name = name_or_hash
    end
    
    unless(type.is_a?(Class) || type.is_a?(Heading))
      type = type.class
    end
    
    @name = name.to_s
    @type = type
  end
  
  def eql? other
    self == other
  end
  
  def hash
    name.hash + type.hash
  end
  
  def == object
    if object.equal?(self)
      true
    elsif !self.class.equal?(object.class)
      false
    else
      object.name == self.name && object.type == self.type
    end
  end
  
end

