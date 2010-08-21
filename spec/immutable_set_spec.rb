require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe ImmutableSet do
  describe :new do
    it 'returns a new instance of ImmutableSet with the supplied values' do
      ImmutableSet.new(:a).should be_instance_of ImmutableSet
      ImmutableSet.new(:a).count.should eql(1)
      
      ImmutableSet.new([:a,:b,:c,:a]).count.should eql(3)
      ImmutableSet.new(ImmutableSet.new([:a,:b,:c,:a])).count.should eql(3)
      
      ImmutableSet.new([:a,:b,:c,:a],[:z],[:y],:o).count.should eql(6)
      ImmutableSet.new([:a,:b,:c,:a],[:z],[:y],ImmutableSet.new([:o])).count.should eql(6)
    end
  end
  
  describe :each do 
    it 'iterates over each value' do
      ImmutableSet.new([:a,:b,:c]).each do |value|
        [:a,:b,:c].should include value
      end
    end
  end
  
  describe :count do
    it 'returns the amount of items in the set' do
      ImmutableSet.new([:a,:b,:c]).count.should eql(3)
    end
  end
  
  describe :size do
    it 'returns the amount of items in the set' do
      ImmutableSet.new([:a,:b,:c]).size.should eql(3)
    end
  end
  
  describe :include? do
    it 'should be true when it contains the value' do
      ImmutableSet.new([:a,:b,:c]).include?(:a).should be_true
      ImmutableSet.new([:a,:b,:c]).include?(:z).should be_false
    end
  end
  
  describe :eql? do
    it 'returns true if the two sets are equal' do
      ImmutableSet.new([:a,:b,:c]).eql?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:a,:b]).eql?(ImmutableSet.new([:a,:b,:c])).should be_false
    end
  end
  
  describe :hash do
    it 'always returns the same value for two sets that are equal' do
      ImmutableSet.new([:a,:b,:c]).hash.should eql(ImmutableSet.new([:a,:b,:c]).hash)
    end
  end
  
  describe :add do
    it 'should result in a new set with the supplied value' do
      ImmutableSet.new(:a).add(:b).add(:a).count.should eql(2)
      ImmutableSet.new(:a).add([:b,:a,:c]).add(:a).count.should eql(3)
      ImmutableSet.new(:a).add(ImmutableSet.new([:d])).add(:a).count.should eql(2)
      
      ImmutableSet.new(:a).add(:b,:f).add(:a).count.should eql(3)
      ImmutableSet.new(:a).add([:b,:a,:c]).add(:a,:ue).count.should eql(4)
      ImmutableSet.new(:a).add(ImmutableSet.new([:d]),:htuneo).add(:a).count.should eql(3)
    end
  end
  
  describe :union do
    it 'should result in a new set with the supplied value' do
      ImmutableSet.new(:a).union(:b).union(:a).count.should eql(2)
      ImmutableSet.new(:a).union([:b,:a,:c]).union(:a).count.should eql(3)
      ImmutableSet.new(:a).union(ImmutableSet.new([:d])).union(:a).count.should eql(2)
      
      ImmutableSet.new(:a).union(:b,:f).union(:a).count.should eql(3)
      ImmutableSet.new(:a).union([:b,:a,:c]).union(:a,:ue).count.should eql(4)
      ImmutableSet.new(:a).union(ImmutableSet.new([:d]),:htuneo).union(:a).count.should eql(3)
    end
  end
  
  describe :delete do
    it 'should delete a value from the set' do
      ImmutableSet.new(:a).add(:b).delete(:a).count.should eql(1)
      ImmutableSet.new([:a,:b,:c,:e]).delete(ImmutableSet.new([:a,:b])).count.should eql(2)
      ImmutableSet.new([:a,:b,:c,:e]).delete([:a,:b]).count.should eql(2)
      
      ImmutableSet.new(:a).add(:b).delete(:a,:b).count.should eql(0)
      ImmutableSet.new([:a,:b,:c,:e]).delete(ImmutableSet.new([:a,:b]),:c).count.should eql(1)
      ImmutableSet.new([:a,:b,:c,:e]).delete([:a,:b],:e).count.should eql(1)
    end
  end
  
  describe :subset? do
    it 'should return true when all values in the supplied set is also in the current set' do
      
      ImmutableSet.new([:a,:b]).subset?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:b,:c]).subset?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:a,:b,:c]).subset?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:a,:b,:c]).subset?(ImmutableSet.new([:b,:c,:gi])).should be_false
      
    end
  end
  
  describe :proper_subset? do
    it 'should return true when all values in the supplied set is also in the current set' do
      
      ImmutableSet.new([:a,:b]).proper_subset?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:b,:c]).proper_subset?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:a,:b,:c]).proper_subset?(ImmutableSet.new([:a,:b,:c])).should be_false
      ImmutableSet.new([:a,:b,:c]).proper_subset?(ImmutableSet.new([:b,:c,:gi])).should be_false
      
    end
  end
  
  describe :proper_subset_of? do
     it 'should return true when all values in the supplied set is also in the current set but they are not equal' do

        ImmutableSet.new([:a,:b]).proper_subset_of?(ImmutableSet.new([:a,:b,:c])).should be_true
        ImmutableSet.new([:b,:c]).proper_subset_of?(ImmutableSet.new([:a,:b,:c])).should be_true
        ImmutableSet.new([:a,:b,:c]).proper_subset_of?(ImmutableSet.new([:a,:b,:c])).should be_false
        ImmutableSet.new([:a,:b,:c]).proper_subset_of?(ImmutableSet.new([:b,:c,:gi])).should be_false

      end
  end
  
  describe :superset? do
    it 'should return true when all values in the supplied set is also in the current set but they are not equal' do
      
      ImmutableSet.new([:a,:b,:c]).superset?(ImmutableSet.new([:a,:b])).should be_true
      ImmutableSet.new([:a,:b,:c]).superset?(ImmutableSet.new([:b,:c])).should be_true
      ImmutableSet.new([:a,:b,:c]).superset?(ImmutableSet.new([:a,:b,:c])).should be_true
      ImmutableSet.new([:a,:b,:c]).superset?(ImmutableSet.new([:gi])).should be_false
      
    end
  end
  
  describe :proper_superset? do
     it 'should return true when all values in the supplied set is also in the current set' do

       ImmutableSet.new([:a,:b,:c]).proper_superset?(ImmutableSet.new([:a,:b])).should be_true
       ImmutableSet.new([:a,:b,:c]).proper_superset?(ImmutableSet.new([:b,:c])).should be_true
       ImmutableSet.new([:a,:b,:c]).proper_superset?(ImmutableSet.new([:a,:b,:c])).should be_false
       ImmutableSet.new([:a,:b,:c]).proper_superset?(ImmutableSet.new([:gi])).should be_false

     end
   end
   
   describe :complement do
     it 'should return a new set with set1 minues the values of set2' do
       ImmutableSet.new([:a,:b,:c]).complement(ImmutableSet.new([:a,:b])).should eql(ImmutableSet.new([:c]))
       ImmutableSet.new([:a,:b,:c]).complement(ImmutableSet.new([:a])).should eql(ImmutableSet.new([:c,:b]))
     end
   end
   
   describe :intersect do
     it 'should return a new set with the values that are fonud in both set1 and set2' do
        ImmutableSet.new([:a,:b,:c]).intersect(ImmutableSet.new([:a,:b])).should eql(ImmutableSet.new([:a,:b]))
        ImmutableSet.new([:a,:b,:c]).intersect(ImmutableSet.new([:a])).should eql(ImmutableSet.new([:a]))
      end
   end
end

