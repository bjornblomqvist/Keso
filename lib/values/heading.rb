
class Heading
  
  def initialize values = nil
    @attributes = ImmutableSet.new
    
    if values.is_a? Attribute
      @attributes = @attributes.add values
    elsif values.is_a? ImmutableSet
      @attributes = values
    elsif values.is_a? Hash
      @attributes = @attributes.add(Attribute.new(values))
    elsif values.nil?
      # Nil is the same as a no params
    else
      raise 'Invalid parameter, expected a hash with name and type or a attribute'
    end
  end
  
  def add values
    if values.is_a? Attribute
      Heading.new(@attributes.add(values))
    elsif values.is_a? Hash
      Heading.new(@attributes.add(Attribute.new(values)))
    end
  end
  
  def == object
    if object.equal?(self)
      true
    elsif !self.class.equal?(object.class)
      false
    else
      self.get_attributes.eql?(object.get_attributes)
    end
  end
  
  def eql? other
    self == other
  end
  
  def [] attribute_name
    @attributes.to_a.each do |value|
      if value.name == attribute_name.to_s
        return value
      end
    end
    
    nil
  end
  
  def remove attribute_or_name
    if attribute_or_name.is_a? Attribute
      Heading.new(@attributes.remove(attribute_or_name))
    else
      result = nil
      @attributes.to_a.each do |value|
        if value.name == attribute_or_name.to_s
          result = value
        end
      end
      if result
        Heading.new(@attributes.remove(result))
      else
        Heading.new @attributes
      end
    end
  end
  
  def count
    @attributes.count
  end
  
  def first 
    @attributes.to_a.first
  end
  
  protected
  
  def get_attributes
    @attributes
  end
  
end



