
class ImmutableHash
  
  def initialize key_or_hash = nil,value = nil
    
    @hash = {}
    
    if key_or_hash.is_a?(ImmutableHash)
      @hash = key_or_hash.inner_hash
    elsif key_or_hash.is_a?(Hash)
      if(key_or_hash.frozen?) 
        @hash = key_or_hash
      else
        @hash = key_or_hash.dup
      end
    elsif !key_or_hash.nil?
      @hash[key_or_hash] = value
    end
    
    @hash.freeze
  end
  
  def [] key
    @hash[key]
  end
  
  def set key_or_hash,value = nil
    add key_or_hash,value
  end

  def keys
    @hash.keys
  end
  
  def values
    @hash.values
  end
  
  def count
    @hash.count
  end
  
  def size
    @hash.size
  end
  
  def - to_remove
    delete to_remove
  end
  
  def each
    @hash.each do |key,value|
      yield key,value
    end
  end
  
  def delete *to_remove
    
    newHash = @hash.dup
    
    to_remove.each do |to_remove|
      if to_remove.is_a?(ImmutableHash) || to_remove.is_a?(Hash)
        to_remove.keys.each do |value|
          newHash.delete value if newHash[value] == to_remove[value]
        end
      elsif to_remove.is_a? Array 
        to_remove.each do |value|
          newHash.delete value
        end
      else
        newHash.delete to_remove
      end
    end
    
    ImmutableHash.new newHash.freeze
  end
  
  def add key_or_hash,value = nil
    if key_or_hash.is_a?(ImmutableHash) || key_or_hash.is_a?(Hash)
      newHash = @hash.dup
      key_or_hash.keys.each do |key|
        newHash[key] = key_or_hash[key]
      end
      ImmutableHash.new(newHash.freeze)
    else
      newHash = @hash.dup
      newHash[key_or_hash] = value
      ImmutableHash.new newHash.freeze
    end
  end
  
  def == object
    eql? object
  end
  
  def eql?(object)
    if object.equal?(self)
      true
    elsif !self.class.equal?(object.class)
      false
    else
      self.inner_hash.eql?(object.inner_hash)
    end
  end
  
  def hash
    @hash.hash
  end
  
  protected
  
  def inner_hash
    @hash
  end
  
end


