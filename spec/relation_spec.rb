
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Relation do
  
  describe :count do 
    it 'returns the tupel count in the set' do
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).count.should eql 1
    end
  end
  
  describe :add do
    it 'returns a new relation with the added tuple' do
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).count.should eql 2
    end 
    
    it 'throws an exception as the supplied value is not a tuple' do
      lambda { Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add("") }.should raise_error(ArgumentError)
    end
    
    it 'throws an exception as the supplied tuple is not of the same heading as the relation' do
      lambda { Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:something => 'Emma',:age => 30})) }.should raise_error(ArgumentError)
    end
    
    it 'throws an exception as the relational value is of the wrong heading' do
      
      person = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      person_with_length = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29,:length => 155})).add(Tuple.new({:name => 'Emma',:age => 30, :length => 135}))
      
      company = Relation.new(Tuple.new({:name => 'Test AB',:employes => person}))
      
      lambda { company = company.add(Tuple.new({:name => 'Nordea AB',:employes => person})) }.should_not raise_error(ArgumentError)
      lambda { company = company.add(Tuple.new({:name => 'SEB AB',:employes => person_with_length})) }.should raise_error(ArgumentError)
      
      
    end
    
  end
  
  describe :subset_of? do
    it 'returns return true when the supplied value is a subset' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).subset_of?(a).should be_true
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 30})).subset_of?(a).should be_false
    end
  end
  
  #   r1.proper_subset(r2) # boolean result
  describe :proper_subset_of? do
    it 'should return true when all values are also in the supplied set and they are not equal' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).proper_subset_of?(a).should be_true
      a.proper_subset_of?(a).should be_false
    end
  end
  
  #   r1.superset(r2) # boolean result
  describe :superset_of? do
    it 'should return true when all the tuples of the supplied set can be found in this set' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      a.superset_of?(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))).should be_true
      a.superset_of?(Relation.new(Tuple.new({:name => 'Bjor'}))).should be_false
      a.superset_of?(a).should be_true
    end
  end
  
  #   r1.proper_superset(r2) # boolean result
  describe :proper_superset_of? do
    it 'should return true when all the tuples of the supplied set is also in this set but they are not equal' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      
      a.proper_superset_of?(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))).should be_true
      a.proper_superset_of?(Relation.new(Tuple.new({:name => 'Bjor'}))).should be_false
      a.proper_superset_of?(a).should be_false
    end
  end
  
  #   r1.union(r2) # r1 + r2, set result
  describe :union do
    it 'returns a new relation with the tuples of both' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      b = Relation.new(Tuple.new({:name => 'Frida',:age => 25})).add(Tuple.new({:name => 'Marianna',:age => 32}))
      
      c = Relation.new(Tuple.new({:name => 'Frida',:age => 25})).add(Tuple.new({:name => 'Marianna',:age => 32})).add(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      
      a.union(b).should eql(c)
    end
  end
  
  describe :eql? do
    it 'returns true when two relations have the same value' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      b = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      a.should eql b
    end
  end
  
  describe :== do
    it 'returns true when two relations have the same value' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      b = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      (a == b).should be_true
    end
  end
  
  describe :hash do
    it 'should return the same hash for the same value' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      b = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      a.hash.should eql b.hash
    end
  end
  
  #   r1.intersect(r2) # all in r1 that is also in r2, set result
  describe :intersect do
    it 'should return a new relation all the tuples that are found in both' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      b = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Frida',:age => 25}))
      
      a.intersect(b).should eql(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})))
    end
    
    it 'should throw an exception as the realtions are not of the same headings' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))
      b = Relation.new(Tuple.new({:name => 'Bjorn'}))
      
      lambda { a.intersect(b) }.should raise_error(ArgumentError)
    end
  end
  
  #   r1.complement(r2) # r1 - r2, set result 
  describe :complement do
    it 'should return a new relation that has all the tuples that where not in r2' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      b = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Frida',:age => 25}))
      
      a.complement(b).should eql(Relation.new(Tuple.new({:name => 'Emma',:age => 30})))
    end
    
    it 'should throw an exception with the text ""Not of the same heading""' do
      a = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))
      b = Relation.new(Tuple.new({:name => 'Bjorn'}))
      
      lambda { a.complement(b) }.should raise_error(ArgumentError)
    end
  end

  #    r1.project_all_but('Name','age') # results in a relation with all attributes exepct the supplied ones, set result
  describe :project_all_but do
    it 'should return a new relation with all but the supplied columns' do
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).project_all_but(:name).should eql(Relation.new(Tuple.new({:age => 30})).add(Tuple.new({:age => 29})))
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).project_all_but(:name,:age).should eql(Relation.new())
    end
  end
  
  
  #    r1.project('Name','age') # results in a relation of only the supplied attributes, set result
  describe :project do
    it 'should return with a new relation with only the attributes named in the argument' do
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).project(:name).should eql(Relation.new(Tuple.new({:name => 'Bjorn'})).add(Tuple.new({:name => 'Emma'})))
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).project(:name,:age).should eql(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})))
    end
    
    it 'should throw an exception as the attribue name is not in the relation' do
      lambda { Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).project(:names)  }.should raise_error(ArgumentError)
    end
  end
  
  #    r1.rename('Name','PersonName') # changes the attribute name from "Name" to "PersonName", set result
  describe :rename do
    it 'should change the name of a tuple' do
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).rename(:name,:new_name).should eql(Relation.new(Tuple.new({:new_name => 'Bjorn',:age => 29})).add(Tuple.new({:new_name => 'Emma',:age => 30})))
    end
    
    it 'should throw an exception ' do
      lambda { Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).rename(:old_name,:new_name) }.should raise_error(ArgumentError)
      lambda { Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).rename(:name,:age) }.should raise_error(ArgumentError)
    end
  end
  
  
  describe :new do
    
    it 'should accept a relation as a type' do
      
      persons = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      
      Relation.new(Tuple.new({:name => 'Test AB',:employes => persons})).each do |tuple|
        tuple.employes.should eql(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})))
      end
    end
    
  end
  
  describe :each do
    it 'iterates over all the tuples and executes the given block' do
      
      names = {}
      
      Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).each do |tuple|
        names[tuple[:name]] = tuple[:name]
      end
      
      names['Bjorn'].should_not be_nil
      names['Emma'].should_not be_nil
      
    end
  end
  
  # r1.select do |r| r.age = 18 end
  describe :select do
    it 'should return only the tuples with age 29' do
      result = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).select do |tuple|
        tuple.age == 29
      end
      
      result.should eql(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})))
    end
    
    it 'should return only the tuples with age greater than 18' do
      result = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})).select do |tuple|
        tuple.age > 18
      end
      
      result.should eql(Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30})))
    end
  end
  
  #    r1.join(r2) do |tupel| ... end 
  describe :join do
    it 'returns a new relation that is the result of join r1 with r2' do
      r1 = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      r2 = Relation.new(Tuple.new({:name => 'Bjorn',:length => 185})).add(Tuple.new({:name => 'Emma',:length => 115})).rename(:name,:name2)
      
      result = r1.join(r2) do |tupel|
        tupel.name == tupel.name2
      end
      
      r3 = Relation.new(Tuple.new({:name => 'Bjorn',:name2 => 'Bjorn',:length => 185,:age => 29})).add(Tuple.new({:name => 'Emma',:name2 => 'Emma',:length => 115, :age => 30}))
      
      result.count.should eql(r3.count)
      result.heading.should eql(r3.heading)
      result.should eql(r3)
      
    end
    
    it 'returns a new relation that is the result of join r1 with r2' do
      r1 = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      r2 = Relation.new(Tuple.new({:name => 'Bjorn',:length => 185})).add(Tuple.new({:name => 'Emma',:length => 115})).rename(:name,:name2)
      
      result = r1.join(r2) do |tupel|
        tupel.name != tupel.name2
      end
      
      r3 = Relation.new(Tuple.new({:name => 'Bjorn',:name2 => 'Emma',:length => 115,:age => 29})).add(Tuple.new({:name => 'Emma',:name2 => 'Bjorn',:length => 185, :age => 30}))
      
      result.count.should eql(r3.count)
      result.heading.should eql(r3.heading)
      result.should eql(r3)
      
    end
  end
  
  
  #    r1.cartesian_product(r2) # new relation with r1 * r2 tuples with all attributes of r1 and r2, set result
  describe :cartesian_product do
    it 'should return a new relation' do
      r1 = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      r2 = Relation.new(Tuple.new({:name => 'Bjorn',:length => 185})).add(Tuple.new({:name => 'Emma',:length => 115})).rename(:name,:name2)

      result = r1.cartesian_product(r2)

      r3 = Relation.new(Tuple.new({:name => 'Bjorn',:name2 => 'Emma',:length => 115,:age => 29})).add(Tuple.new({:name => 'Emma',:name2 => 'Bjorn',:length => 185, :age => 30})).add(Tuple.new({:name => 'Bjorn',:name2 => 'Bjorn',:length => 185,:age => 29})).add(Tuple.new({:name => 'Emma',:name2 => 'Emma',:length => 115, :age => 30}))

      result.count.should eql(r3.count)
      result.heading.should eql(r3.heading)
      result.should eql(r3)

    end
  end
  
  #    r1.natrual_join(r2) # cartesian_product with a selection based on equal attributes having to have equal value, set result  
  describe :natrual_join do
    it 'returns a new relation that is the result of join r1 with r2' do
      r1 = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29})).add(Tuple.new({:name => 'Emma',:age => 30}))
      r2 = Relation.new(Tuple.new({:name => 'Bjorn',:length => 185})).add(Tuple.new({:name => 'Emma',:length => 115}))
      
      result = r1.natrual_join(r2)
      
      r3 = Relation.new(Tuple.new({:name => 'Bjorn',:length => 185,:age => 29})).add(Tuple.new({:name => 'Emma',:length => 115, :age => 30}))
      
      result.count.should eql(r3.count)
      result.heading.should eql(r3.heading)
      result.should eql(r3)
      
    end
  end
  
end


