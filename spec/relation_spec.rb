
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
  
end


