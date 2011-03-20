
require 'set'

class ImmutableSet
  
  def initialize(*args) 
    
    if args.first.is_a? ImmutableSet::SetChange
      @set_change = args.first
    else
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
    
  end
  
  def size
    self.set.size
  end
  
  alias :count :size
  
  def each &block
    self.set.to_a.each do |value|
      block.call value
    end
  end
  
  def add *values
    ImmutableSet.new(SetChange.new(values,@set || @set_change.set,true,@set_change))
  end
  
  def hash
    self.set.hash
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
    ImmutableSet.new(SetChange.new(values,@set || @set_change.set,false,@set_change))
  end
  
  alias :remove :delete
  
  def to_a
    self.set.to_a
  end
  
  def include? value
    self.set.include? value
  end
  
  
  
  
  
  
  
  def subset? other_set
    self.set.subset?(other_set.set)
  end
  
  def superset? other_set
    self.set.superset?(other_set.set)
  end
  
  alias :superset_of? :superset?
  
  def proper_subset? other_set
    self.set.proper_subset?(other_set.set)
  end
  
  alias :proper_subset_of? :proper_subset?
  
  def proper_superset? other_set
    self.set.proper_superset?(other_set.set)
  end
  
  alias :proper_superset_of? :proper_superset?
  
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
    @set ||= @set_change.unrole
  end
  
  class SetChange
    
    def initialize values,set,add,set_change
      
      raise "set must be supplied" unless set
      raise "values must be supplied" unless values
      
      @values = values
      @set = set
      @add = add
      @set_change = set_change
      @depth = 0
      
      if set_change
        # We need to unrole when we have a depth of more than 500 so that we dont couse a SystemStackError
        if set_change.depth > 4000
          @set_change = nil
          @set = set_change.unrole
        else
          @depth = set_change.depth + 1
        end
      end
    end
    
    def set
      @set
    end
    
    def depth
      @depth
    end
    
    def add_change_to_set set
      
      @set_change.add_change_to_set(set) if @set_change
      
      if @add
        @values.each do |value|
          if value.is_a? ImmutableSet
            set.merge(value.to_a)
          elsif value.is_a? Set
            set.merge(value)
          elsif value.is_a? Array
            set.merge(value)
          else
            set.add(value)
          end
        end
      else
        @values.each do |value|
          if value.is_a? ImmutableSet
            set.subtract(value.to_a)
          elsif value.is_a? Set
            set.subtract(value)
          elsif value.is_a? Array
            set.subtract(value)
          else
            set.delete(value)
          end
        end
      end
      
      set
    end
    
    def unrole
      self.add_change_to_set(@set.clone)
    end
    
  end
  
end

