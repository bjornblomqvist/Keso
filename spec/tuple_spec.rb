require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Tuple do
  
  #
  # {:a => 4,:b => 4 ,:c => 4} + {:y => 4} == {:a => 4,:b => 4,:c => 4,:y => 4}
  # {:a => 4,:b => 4 ,:c => 4}.add y == {a,b,c,y}
  # {:a => 4,:b => 4 ,:c => 4}.add [y,t] == {a,b,c,y,t}
  # {:a => 4,:b => 4 ,:c => 4} - c == {a,b}
  # {:a => 4,:b => 4 ,:c => 4}.remove c == {a,b}
  # {:a => 4,:b => 4 ,:c => 4}.remove [a,c] == {b}
  # {x,y}.eql? {x,y}
  # {x,y} == {x,y} 
  # {x,y}.heading == {x,y}.heading
  # {x,y}.count == 2
  #
  
  describe :heading do
    it 'retuns the heading of the tuple' do
      Tuple.new({'a' => :b,'c' => :y}).heading.should be_an_instance_of Heading
      Tuple.new({'a' => :b,'c' => :y}).heading.should eql(Heading.new.add(:name => 'a', :type => Symbol).add(:name => 'c', :type => Symbol))
    end
  end
  
  describe :[] do
    it 'returns the value of the named attribute' do
      Tuple.new({:c => 3})[:c].should eql 3
      Tuple.new({:name => 'Bjorn'})[:name].should eql 'Bjorn'
    end
  end
  
  describe :count do
    it 'returns the amount of values that are part of the tuple' do
      Tuple.new({:a => :b,:c => :y}).count.should eql(2)
      Tuple.new({:a => :b,:c => :y,:g => 'ee',:htn => 21}).count.should eql(4)
    end
  end
  
  describe :new do
    it 'returns a new tuple value of suplied values' do
      Tuple.new({:a => "b",:c => "ue"}).should be_an_instance_of Tuple 
      Tuple.new({:c => 3}).should be_an_instance_of Tuple
    end
  end
  
  describe :add do
    it 'returns a new value of current value plus the supplied value' do
      Tuple.new({:b => 4,:c => 4, :d => 4}).add({:g => 32}).should eql(Tuple.new(:b => 4,:c => 4, :d => 4,:g => 32))
      Tuple.new({:b => 4,:c => 4, :d => 4}).add(:g => 32,:gd => 32).should eql(Tuple.new(:b => 4,:c => 4, :d => 4,:g => 32,:gd => 32))
    end
    
    it 'returns a new tuple with the attributes of both' do
      Tuple.new({:b => 4,:c => 4, :d => 4}).add(Tuple.new({:test => "Hi this is my test"})).should eql(Tuple.new({:b => 4,:c => 4, :d => 4,:test => "Hi this is my test"}))
    end
    
    it 'should throw an exception' do
      lambda {Tuple.new({:b => 4,:c => 4, :d => 4}).add(Tuple.new({:d => "Hi this is my test"}))}.should raise_error(ArgumentError)
    end
  end
  
  describe :remove do
    it 'returns a new value of current values minus the supplied values' do
      Tuple.new({:a => :b,:c => :y,:g => 'ee',:htn => 21}).remove(:htn => 21).count.should eql 3
      Tuple.new({:a => :b,:c => :y,:g => 'ee',:htn => 21}).remove(:htn => 21).should eql(Tuple.new(:a => :b,:c => :y,:g => 'ee'))
      Tuple.new(:a => :b,:c => :y,:g => 'ee').remove(:g => 'ee',:a => :b).should eql(Tuple.new({:c => :y}))
      Tuple.new({:g => 'ee',:htn => 21}).remove({:g => 'ee',:htn => 21}).should eql(Tuple.new())
      Tuple.new(:g => 'ee',:htn => 21).remove(:g => 'ee',:htn => 21).should_not eql(Tuple.new(:g => 'ee',:htn => 21))
      Tuple.new({:g => 'ee',:htn => 21}).remove(:g).should eql(Tuple.new(:htn => 21))
      Tuple.new({:g => 'ee',:htn => 21}).remove(:g,:htn).should eql(Tuple.new())
      Tuple.new({:g => 'ee',:htn => 21}).remove([:g,:htn]).should eql(Tuple.new())
    end
  end
  
  describe :hash do
    it 'returns the same hash for the same value' do
      
      Tuple.new(:g => 'ee',:htn => 21).hash.should eql(Tuple.new(:g => 'ee',:htn => 21).hash)
      Tuple.new(:g => 'ee',:htn => 21).hash.should_not eql(Tuple.new(:g => 'ee',:htn => 22).hash)
      
    end
  end
  
  describe :each do
    it 'iterates over all the attributes in the tuple' do
      
      new_tuple = Tuple.new
      
      Tuple.new(:g => 'ee',:htn => 21).each do |attribute,value|
        new_tuple = new_tuple.add attribute,value
      end
      
      new_tuple.should eql(Tuple.new(:g => 'ee',:htn => 21))
    end
  end
  
  describe :rename do
    it 'changes the name of a attribute' do
      Tuple.new(:g => 'ee',:htn => 21).rename(:g,:d).should eql(Tuple.new(:d => 'ee',:htn => 21))
    end
    
    it 'should throw an exception' do
      lambda { Tuple.new(:g => 'ee',:htn => 21).rename(:missing,:d) }.should raise_error(ArgumentError)
      lambda { Tuple.new(:g => 'ee',:htn => 21).rename(:g,:htn) }.should raise_error(ArgumentError)
    end
  end
  
  describe :eql? do
    it 'returns true if the supplied value is equal to this one' do
      Tuple.new().eql?(Tuple.new()).should be_true
      
      Tuple.new(:g => 'ee',:htn => 21).eql?(Tuple.new(:g => 'ee').add(:htn => 21)).should be_true
      
      Tuple.new({:g => 'ee',:htn => 21}).eql?(Tuple.new({:g => 'ee',:htn => 21})).should be_true
      
      Tuple.new(:g => 'ee',:htn => 21).eql?(Tuple.new(:g => 'ee',:htn => 22)).should be_false
    end
  end
  
  
end


