require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ImmutableHash do
  
  describe :new do
    it 'takes a ruby hash as argument and returns a ImmutableHash with entries from the supplied hash' do
      ih = ImmutableHash.new({:a => :b})
      ih.should be_an_instance_of ImmutableHash
      ih[:a].should eql(:b)
    end
    
    it 'returns a ImmutableHash' do
      ImmutableHash.new.should be_an_instance_of ImmutableHash
    end
  end
  
  
  describe :keys do
    it 'returns an array of all keys' do
      ImmutableHash.new({:a => :b}).keys.should eql([:a])
    end
  end
  
  describe :values do 
    it 'returns an array of all values' do
      ImmutableHash.new({:a => :b}).values.should eql([:b])
    end
  end
  
  describe :size do
    it 'should return the amount of entries in the hash' do
      ImmutableHash.new({:a => :b}).size.should eql(1)
      ImmutableHash.new({:a => :b,:c => :b}).size.should eql(2)
    end
  end
  
  describe :count do
    it 'should return the amount of entries in the hash' do
      ImmutableHash.new({:a => :b}).size.should eql(1)
      ImmutableHash.new({:a => :b,:c => :b}).size.should eql(2)
    end
  end
  
  describe :[] do
    it 'returns nil or the value pointed to by the key' do
       ImmutableHash.new({:a => :b})[:a].should eql(:b)
       ImmutableHash.new({:a => :b})[:c].should be_nil
    end
  end
  
  describe :add do
    it 'creates a new hash with all the entries plus a new of from the key and value parameters' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.add :c,:d
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
    
    it 'can take a hash and returns a new imutable instance with all the current entries plus the ones from the hash' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.add({:e => :f,:c => :d})
      ih2.count.should eql(3)
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
    
    it 'can take another imutable hash and returns a new instance with the entries of both' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.add ImmutableHash.new({:e => :f,:c => :d})
      ih2.count.should eql(3)
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
  end
  
  describe :set do
    it 'creates a new hash with all the entries plus a new of from the key and value parameters' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.set :c,:d
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
    
    it 'can take a hash and returns a new imutable instance with all the current entries plus the ones from the hash' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.set({:e => :f,:c => :d})
      ih2.count.should eql(3)
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
    
    it 'can take another imutable hash and returns a new instance with the entries of both' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.set ImmutableHash.new({:e => :f,:c => :d})
      ih2.count.should eql(3)
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
  end
  
  describe :+ do
    it 'creates a new hash with all the entries plus a new of from the key and value parameters' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.add :c,:d
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
    
    it 'can take a hash and returns a new imutable instance with all the current entries plus the ones from the hash' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.add({:e => :f,:c => :d})
      ih2.count.should eql(3)
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
    
    it 'can take another imutable hash and returns a new instance with the entries of both' do
      ih1 = ImmutableHash.new({:a => :b})
      ih2 = ih1.add ImmutableHash.new({:e => :f,:c => :d})
      ih2.count.should eql(3)
      ih2.should_not eql(ih1)
      ih2[:c].should eql(:d)
      ih1[:c].should be_nil
    end
  end
  
  describe :delete do
    it 'returns a new instance of ImmutableHash without the supplied key' do
      ImmutableHash.new({:a => :b}).delete(:a).count.should eql(0)
    end
    
    it 'returns a new instance of ImmutableHash without the supplied keys' do
      ImmutableHash.new({:a => :b,:b => :c}).delete([:a,:b]).count.should eql(0)
    end
    
    it 'returns a new instance of ImmutableHash without the entries from the supplied hash' do
      ImmutableHash.new({:a => :b,:b => :c}).delete({:b => :b,:a => :b}).count.should eql(1)
    end
    
    it 'returns a new instance of ImmutableHash without the entries from the supplied imutable hash' do
      ImmutableHash.new({:a => :b,:b => :c}).delete(ImmutableHash.new({:b => :b,:a => :b})).count.should eql(1)
    end
  end
   
  describe :== do
    it 'retuns true if both instances are equal' do
      (ImmutableHash.new({:a => :b,:b => :c}) == ImmutableHash.new({:a => :b,:b => :c})).should be_true
    end
  end
  
  describe :eql? do
    it 'returns true if the supplied value is eql to this one' do
      (ImmutableHash.new({:a => :b,:b => :c}).eql?(ImmutableHash.new({:a => :b,:b => :c}))).should be_true
    end
  end
  
  describe :hash do
    it 'always returns the same integer for the same value' do
      ImmutableHash.new({:a => :b,:b => :c}).hash.should eql(ImmutableHash.new({:a => :b,:b => :c}).hash)
    end
  end
  
  describe :- do
    it 'returns a new instance of ImmutableHash without the supplied key' do
      (ImmutableHash.new({:a => :b}) - :a).count.should eql(0)
    end
    
    it 'returns a new instance of ImmutableHash without the supplied keys' do
      (ImmutableHash.new({:a => :b,:b => :c}) - [:a,:b]).count.should eql(0)
    end
    
    it 'returns a new instance of ImmutableHash without the entries from the supplied hash' do
      (ImmutableHash.new({:a => :b,:b => :c}) - {:b => :b,:a => :b}).count.should eql(1)
    end
    
    it 'returns a new instance of ImmutableHash without the entries from the supplied imutable hash' do
      (ImmutableHash.new({:a => :b,:b => :c}) - ImmutableHash.new({:b => :b,:a => :b})).count.should eql(1)
    end
  end

  describe :each do
    it 'takes a code block that and for each key => value it yiels' do
      hash = {}
      ImmutableHash.new({:a => :b,:b => :c}).each do |key,value|
        hash[key] = value;
      end
      
      hash.should eql({:a => :b,:b => :c})
    end
  end

end