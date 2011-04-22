
class Heading
  
  def initialize values = nil
    @attributes = ImmutableSet.new
    
    if values.is_a? Attribute
      @attributes = @attributes.add values
    elsif values.is_a? ImmutableSet
      @attributes = values
    elsif values.is_a? Array
      @attributes = ImmutableSet.new values
    elsif values.is_a? Hash
      @attributes = @attributes.add(Attribute.new(values))
    elsif values.is_a? Heading
      values.get_attributes.each do |attribute|
        @attributes = @attributes.add(attribute)
      end
    elsif values.nil?
      # Nil is the same as a no params
    else
      raise 'Invalid parameter, expected a hash with name and type or a attribute'
    end
    
    # Validate
    @attribute.each do |a|
      raise "Invalid input, all values must be an attribute or hash that creats an attribute" unless a.is_a? Attribute
    end
  end
  
  def names
    toReturn = []
    @attributes.each do |attribute|
      toReturn << attribute.name
    end
    
    toReturn
  end
  
  def add values
    if values.is_a? Attribute
      Heading.new(@attributes.add(values))
    elsif values.is_a? Hash
      Heading.new(@attributes.add(Attribute.new(values)))
    elsif values.is_a? Heading
      toReturn = Heading.new(self)
      values.get_attributes.each do |attribute|
        toReturn = toReturn.add(attribute)
      end
      toReturn
    else
      throw "Unknown argument #{values.class}"
    end
  end
  
  def hash
    @attributes.hash
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
  
  def each &block
    @attributes.each do |value|
      block.call value
    end
  end
  
  def [] attribute_name
    @attributes.to_a.each do |value|
      if value.name == attribute_name.to_s
        return value
      end
    end
    
    nil
  end
  
  def rename from,to
    throw "Missing from" if self[from].nil?
    throw "to already exists" unless self[to].nil?
    
    Heading.new(@attributes).remove(from).add(:name => to, :type => self[from].type)
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



