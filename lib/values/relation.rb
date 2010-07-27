
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
#   r1.p_subset(r2) # boolean result
#   r1.superset(r2) # boolean result
#   r1.proper_superset(r2) # boolean result
#   r1.p_superset(r2) # boolean result
#   r1.union(r2) # r1 + r2, set result
#   r1.intersect(r2) # all in r1 that is also in r2, set result
#   r1.complement(r2) # r1 - r2, set result 



# 
# Relational methods
# 
#    r1.project('Name','age') # results in a relation of only the supplied attributes, set result
#    r1.select('age' >= 18) # results in a raltion with where ('age' >= 18) is true, set result
#    r1.rename('Name','PersonName') # changes the attribute name from "Name" to "PersonName", set result
#    r1.natrual_join(r2) # cartesian_product with a selection based on equal attributes having to have equal value, set result
#    r1.cartesian_product(r2) # new relation with r1 * r2 tuples with all attributes of r1 and r2, set result
#
# i am missing summary functions
#
#
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
  
  def initialize value
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
    else
      raise "Only accept Tuple,Heading,Relation or Hash types"
    end
  end
  
  def cartesian_product other_relation
    
  end 
  
  def add tuple
    if tuple.is_a? Tuple
      if tuple.heading == @heading
        Relation.new(@heading).set_body(@body.add tuple)
      else
        throw 'its not of the same heading!'
      end
    else
      throw "Only tuples are supported"
    end
  end
    
  def count
    @body.size
  end
  
  def each &block
    @body.each do |value|
      block.call value
    end
  end
  
  protected
  
  def set_body body
    @body = body
    self
  end
  
end





