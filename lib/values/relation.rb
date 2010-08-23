
#
# Subset,Superset
#
# Union, Intersection,  Complement, Cartesian, join 
#  natrual_join: Joins two relations based on all common parts of there headers
#


# 
# Ref
# 
#   http://en.wikipedia.org/wiki/Set_%28mathematics%29
#   http://en.wikipedia.org/wiki/Relational_algebra
# 
# Set methods
# 
#   r1.subset(r2) # boolean result
#   r1.proper_subset(r2) # boolean result
#   r1.superset(r2) # boolean result
#   r1.proper_superset(r2) # boolean result
#   r1.union(r2) # r1 + r2, set result
#   r1.intersect(r2) # all in r1 that is also in r2, set result
#   r1.complement(r2) # r1 - r2, set result 



# 
# Relational methods
# 
#    r1.project('Name','age') # results in a relation of only the supplied attributes, set result
#    r1.project_all_but('Name','age') # results in a relation with all attributes exepct the supplied ones, set result
#    r1.rename('Name','PersonName') # changes the attribute name from "Name" to "PersonName", set result
#    r1.select('age' >= 18) # results in a raltion with where ('age' >= 18) is true, set result
#    r1.join(r2) do |tupel| ... end 
#    r1.cartesian_product(r2) # new relation with r1 * r2 tuples with all attributes of r1 and r2, set result
#    r1.natrual_join(r2) # cartesian_product with a selection based on equal attributes having to have equal value, set result  
#    r1.group
#    r1.ungroup

#    r1.summarize(:name) do |tuples,new_tuple|
#       new_tuple.add('avrange_age',avg(tuples,'age'))
#       new_tuple.add('max_age',max(tuples,'age'))
#       new_tuple.add('min_age',min(tuples,'age'))
#       new_tuple.add('median_age',median(tuples,'age'))
#    end

# Tutorial D
#
#    r1.project('Name','Age').group(['Age'],'Names') # results in a new relation as r{'Age' => integer, 'Names' => r{'Name' => String}}
#    r1.project('Name','Age').group(['Age'],'Names').ungroup('Names'[,{'Name' => 'New_name'}]) # results in a new relation as r{'Age' => integer, 'Name' => String}
#
# A relation is a set of tupels constrainted to what can be described as a relational type by a heading, this means that 
# the relation only takes tuples with the same heading as the relation.
#  It has a body
#  It has a heading
#  
#  All parts of the body must of the heading
# 
#    
#    
#    
#    

class Relation
  
  attr_reader :body, :heading
  
  def initialize *value
    value = value[0]
    if value.is_a? Tuple
      @heading = value.heading
      @body = ImmutableSet.new value
    elsif value.is_a? Heading
      @heading = value
      @body = ImmutableSet.new
    elsif value.is_a? Relation
      @heading = value.heading
      @body = value.body
    elsif value.is_a? Hash
      @heading = Heading.new value
      @body = ImmutableSet.new
    elsif value.nil?
      # oo... so you want an empty relation ?
      @heading = Heading.new
      @body = ImmutableSet.new
    else
      raise "Only accept Tuple,Heading,Relation or Hash types"
    end
  end
  
  def add tuple
    if tuple.is_a? Tuple
      if tuple.heading == @heading
        Relation.new(@heading).set_body(@body.add tuple)
      else
        throw 'its not of the same heading!'+", #{tuple.heading.inspect} != #{@heading.inspect}"
      end
    else
      throw "Only tuples are supported"
    end
  end
  
  def subset_of? other_relation
    @body.subset? other_relation.get_body
  end
  
  def proper_subset_of? other_relation
    @body.proper_subset_of? other_relation.get_body
  end
  
  def superset_of? other_relation
    @body.superset_of? other_relation.get_body
  end
  
  def proper_superset_of? other_relation
    @body.proper_superset_of? other_relation.get_body
  end
  
  def union other_relation
    if self.heading == other_relation.heading
      new_body = self.get_body.union(other_relation.get_body)
      new_relation = Relation.new self.heading
      new_relation.set_body new_body
      return new_relation
    else
      throw "Not of the same heading"
    end
  end
  
  def intersect other_relation
    if self.heading == other_relation.heading
      new_body = self.get_body.intersect other_relation.get_body
      new_relation = Relation.new self.heading
      new_relation.set_body new_body
      return new_relation
    else
      throw "Not of the same heading"
    end
  end
  
  def complement other_relation
    if self.heading == other_relation.heading
      new_body = self.get_body.complement other_relation.get_body
      new_relation = Relation.new self.heading
      new_relation.set_body new_body
      return new_relation
    else
      throw "Not of the same heading"
    end
  end
  
  
  
  def project *args
    
    new_heading = Heading.new
    
    args.each do |symbol|
      if self.heading[symbol].nil?
        throw "no attribute with the name #{symbol}"
      end
      
      new_heading = new_heading.add(self.heading[symbol])
    end
    
    if new_heading.count == 0
      return Relation.new new_heading 
    end
    
    new_relation = Relation.new new_heading
    @body.each do |tuple|
      new_tuple = Tuple.new
      
      args.each do |symbol|
        new_tuple = new_tuple.add(symbol => tuple[symbol])
      end
      
      new_relation = new_relation.add new_tuple
    end
    
    
    
    return new_relation
  end
  
  def project_all_but *args
    
    new_heading = Heading.new self.heading
    
    args.each do |symbol|
      if self.heading[symbol].nil?
        throw "no attribute with the name #{symbol}"
      end
      
      new_heading = new_heading.remove symbol
    end
    
    if new_heading.count == 0
      return Relation.new new_heading 
    end
    
    new_relation = Relation.new new_heading
    @body.each do |tuple|
      new_tuple = Tuple.new
      
      new_heading.each do |attribute|
        new_tuple = new_tuple.add(attribute => tuple[attribute.name])
      end
      
      new_relation = new_relation.add new_tuple
    end
    
    return new_relation
  end
  
  def rename from,to
    new_relation = Relation.new self.heading.rename(from,to)
    self.each do |tuple|
      new_relation = new_relation.add tuple.rename(from,to)
    end
    
    new_relation
  end
  
  
    
  def count
    @body.size
  end
  
  def each &block
    @body.each do |value|
      block.call value
    end
  end
  
  
  def select &block
    new_relation = Relation.new self.heading
    self.each do |tuple|
      new_relation = new_relation.add(tuple) if block.call(tuple)
    end
    
    new_relation
  end
  
  
  def join other_relation,&block
    new_relation = Relation.new(self.heading.add(other_relation.heading))
    self.each do |tuple|
      other_relation.each do |tuple2|
        tuple3 = tuple.add(tuple2)
        new_relation = new_relation.add(tuple3) if block.call(tuple3)
      end
    end
    
    new_relation
  end
  
  def cartesian_product other_relation
    self.join other_relation do |tuple|
      true
    end
  end
  
  def natrual_join other_relation
    
    the_same = []
    
    self.heading.each do |attribute|
      other_relation.heading.each do |attribute2|
        if attribute == attribute2
          the_same.push attribute
        end
      end
    end
      
    old_and_new_name = {}
    the_same.each do |value|
      other_relation = other_relation.rename(value.name,value.name+"_2")
      old_and_new_name[value.name] = value.name+"_2"
    end  
    
    to_return = self.join(other_relation) do |tuple|
      
      r = true
      
      old_and_new_name.each do |name,name2|
        unless tuple[name] == tuple[name2]
          r = false
        end  
      end
      
      r
    end
    

    to_return = to_return.project_all_but *(old_and_new_name.values)
    
    to_return
  end
  
  
  def ungroup column_name
    
    new_tuples = []
    self.each do |tuple|
      inner_relation = tuple[column_name]
      tuple = tuple.remove column_name
      inner_relation.each do |inner_tuple|
        temp = tuple
        inner_tuple.each do |attribute,value|
          temp = temp.add({attribute => value})
          new_tuples.push(temp)
        end
      end
    end
    
    new_heading = self.heading.remove column_name
    self.heading[column_name].type.each do |attribute|
      new_heading = new_heading.add attribute
    end
    
    to_return = Relation.new new_heading
    new_tuples.each do |tuple|
      to_return = to_return.add tuple
    end
    
    to_return
  end
  
  def group column_names,new_column_name
    
    # create the headings
    new_heading = Heading.new
    new_inner_heading = self.heading
    
    column_names.each do |column_name|
      new_heading = new_heading.add self.heading[column_name]
    end
    
    column_names.each do |column_name| 
      new_inner_heading = new_inner_heading.remove column_name
    end
    
    new_heading = new_heading.add(:name => new_column_name, :type => new_inner_heading)
    
    # split the data
    temp_data = {}
    
    self.each do |tuple|
      new_tuple = Tuple.new
      new_inner_tuple = Tuple.new

      new_heading.each do |attribute|
        new_tuple = new_tuple.add(attribute => tuple[attribute]) unless attribute.name.to_s == new_column_name.to_s
      end
      
      new_inner_heading.each do |attribute|
        new_inner_tuple = new_inner_tuple.add(attribute => tuple[attribute])
      end
      
      temp_data[new_tuple] ||= []
      temp_data[new_tuple].push new_inner_tuple
    end
    
    
    # create the new realation
    new_relation = Relation.new new_heading
    
    temp_data.each do |tuple,array_of_tuples| 
      
      inner_relation = Relation.new new_inner_heading
      
      array_of_tuples.each do |inner_tuple| 
        inner_relation = inner_relation.add(inner_tuple)
      end
      
      tuple = tuple.add(new_column_name => inner_relation)
      new_relation = new_relation.add(tuple)
    end
    
    new_relation
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
      self.get_body.eql?(other.get_body)
    end
  end
  
  def hash
    self.get_body.hash
  end
  
  protected
  
  def set_body body
    @body = body
    self
  end
  
  def get_body
    @body
  end
  
  
end





