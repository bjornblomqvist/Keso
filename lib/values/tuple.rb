

class Tuple
  
  @hash = nil
  
  def initialize *args
    hash = ImmutableHash.new *args
    @hash = ImmutableHash.new
    @heading = Heading.new
    hash.each do |name_or_attribute,value| 
      if name_or_attribute.is_a? Attribute
        @heading = @heading.add(name_or_attribute)
        @hash = @hash.add(name_or_attribute,value)
      else
        @heading = @heading.add(Attribute.new(name_or_attribute,value.class))
        @hash = @hash.add(Attribute.new(name_or_attribute,value.class),value)
      end
    end
  end
  
  def count
    @hash.count
  end
  
  def heading
    @heading
  end
  
  def [] attribute_name
    @hash[self.heading[attribute_name]]
  end
  
  def add *values
    Tuple.new(@hash.add(*values))
  end
  
  def remove *values
    
    to_return = @hash
    
    values.each do |attribute_or_name|
      if attribute_or_name.is_a? Attribute
        to_return = to_return.delete(attribute_or_name)
      elsif attribute_or_name.is_a? Hash
        attribute_or_name.each do |key,value|
          to_return = to_return.delete(heading[key.to_s])
        end
      elsif attribute_or_name.is_a? Array
        attribute_or_name.each do |name|
          to_return = to_return.delete(heading[name.to_s])
        end
      else
        to_return = to_return.delete(heading[attribute_or_name.to_s])
      end
    end  
    Tuple.new to_return
  end
  
  def eql? object
    self == object
  end
  
  def == object
    if object.equal?(self)
      true
    elsif !self.class.equal?(object.class)
      false
    else
      self.inner_hash.eql?(object.inner_hash)
    end
  end
  
  protected
  
  def inner_hash
    @hash
  end
  
end