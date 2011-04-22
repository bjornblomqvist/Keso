

class Tuple
  
  @hash = nil
  
  def initialize *args
    
    # Fix so that we have the input as a hash
    hash = args.first
    unless(hash.is_a?(Hash) || hash.is_a?(ImmutableHash))  
      hash = {args[0] => args[1]}
    end
    
    if args.length == 0
      hash = {}
    end
    
    
    # Validate and put the input as we want it
    values = {}
    heading = []
    
    hash.each do |name_or_attribute,value| 
      if name_or_attribute.is_a? Attribute
        
        if value.is_a? Relation
          throw "#{value} is not the same as #{name_or_attribute.type}" if value.heading != name_or_attribute.type
        else
          throw "#{value} is not the same as #{name_or_attribute.type}" if value.class != name_or_attribute.type
        end
        
        heading << name_or_attribute
      else
        if value.is_a? Relation
          heading << Attribute.new(name_or_attribute,value.heading)
        else
          heading << Attribute.new(name_or_attribute,value.class)
        end
      end
      
      values[heading.last] = value
    end
    
    # set it
    @hash = ImmutableHash.new values
    @heading = Heading.new heading
    
  end
  
  def count
    @hash.count
  end
  
  def heading
    @heading
  end
  
  def [] attribute_name
    if attribute_name.is_a? String
      @hash[self.heading[attribute_name]]
    elsif attribute_name.is_a? Attribute
      @hash[attribute_name]
    elsif attribute_name.is_a? Symbol
      @hash[self.heading[attribute_name.to_s]]
    else
      throw "What should i do with this ? attribute_name=\"#{attribute_name.inspect}\""
    end
  end
  
  
  def each &block
    @hash.each do |key,value|
      block.call key,value
    end
  end
  
  def add *values
    
    if values.length == 1 and values[0].is_a? Tuple
      to_return = self
      values[0].each do |attribute,value|
        to_return = to_return.add(attribute,value)
      end
      
      to_return
    else
      if values[0].is_a? Attribute
        throw "already exists with this name" unless self.heading[values[0].name].nil?
      elsif values[0].is_a? String
        throw "already exists with this name" unless self.heading[values[0]].nil?
      end
      Tuple.new(@hash.add(*values))
    end
  end
  
  def hash
    @hash.hash
  end
  
  def rename from,to
    throw "Missing from" if self[from].nil?
    throw "to already exists" unless self[to].nil?
    
    to_return = Tuple.new()
    to_return._heading = @heading.rename(from,to)
    to_return._inner_hash = @hash.delete(self.heading[from]).add(Attribute.new(to,self.heading[from].type) ,self[from])
    
    to_return
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
  
  def method_missing name,&args
    self[name.to_sym]
  end
  
  protected
  
  def inner_hash
    @hash
  end
   
  def _heading= value
    @heading = value
  end
  
  def _inner_hash= value
    @hash = value
  end
  
end