
require 'Set'

class ImmutableSet
  
  def initialize(*args) 
    
    @set = Set.new;
    
    args.each do |value|
      if value.is_a? ImmutableSet
        @set.merge value.set
      elsif value.is_a? Set
        @set.merge value
      elsif value.is_a? Array
        @set.merge value
      elsif not value.nil?
        @set.add value
      end
    end
    
  end
  
  def size
    @set.size
  end
  
  alias :count :size
  
  def each &block
    @set.to_a.each do |value|
      block.call value
    end
  end
  
  def add *values
    
    new_set = @set.clone
    
    values.each do |value|
      if value.is_a? ImmutableSet
        new_set.merge(value.to_a)
      elsif value.is_a? Set
        new_set.merge(value)
      elsif value.is_a? Array
        new_set.merge(value)
      else
        new_set.add(value)
      end
    end
    
    ImmutableSet.new(new_set)
  end
  
  def hash
    @set.hash
  end
  
  def eql? other
    self == other
  end
  
  def == other
    if other.equal?(self)
      true
    elsif !self.class.equal?(other.class)
      false
    else
      self.set.eql?(other.set)
    end
  end
  
  def delete *values
    
    new_set = @set.clone
    
    values.each do |value|
      if value.is_a? ImmutableSet
        new_set.subtract(value.to_a)
      elsif value.is_a? Set
        new_set.subtract(value)
      elsif value.is_a? Array
        new_set.subtract(value)
      else
        new_set.delete(value)
      end
    end
    
    ImmutableSet.new(new_set)
  end
  
  alias :remove :delete
  
  def to_a
    @set.to_a
  end
  
  def include? value
    @set.include? value
  end
  
  
  
  
  
  
  
  def subset? other_set
    self.set.subset?(other_set.set)
  end
  
  def superset? other_set
    self.set.superset?(other_set.set)
  end
  
  def proper_subset? other_set
    self.set.proper_subset?(other_set.set)
  end
  
  def proper_superset? other_set
    self.set.proper_superset?(other_set.set)
  end
  
  def union *values
    self.add *values
  end
  
  def complement other_set
    ImmutableSet.new(self.set - other_set.set)
  end
  
  def intersect other_set
    ImmutableSet.new(self.set & other_set.set)
  end
  
  
  
  protected
  
  def set
    @set
  end
  
end

