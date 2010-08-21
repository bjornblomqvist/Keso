require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Heading do

  describe :new do
    it 'creates a new instance of heading with given attribute' do
      Heading.new(Attribute.new(:name => 'a', :type => 1)).first.type.should eql(Fixnum)
    end
    
    it 'creates a new instance of heading with given name and class' do
      Heading.new(:name => 'a', :type => Fixnum).first.type.should eql(Fixnum)
    end

    it 'creates a new instance of heading with given name and value' do
      Heading.new(:name => 'a', :type => 1).first.type.should eql(Fixnum)
    end
    
    it 'throws an exception if given just a symbol' do
      lambda{ Heading.new(:bla) }.should raise_error
    end
    
    it 'creates a new empty heading' do
      Heading.new.first.should be_nil
    end
  end
  
  describe :eql? do
    it 'returns true if two headings has the same attributes' do
        Heading.new(:name => 'a', :type => 1).eql?(Heading.new(:name => 'a', :type => 1)).should be_true
        Heading.new(:name => 'a', :type => 1).eql?(Heading.new(:name => 'b', :type => 1)).should be_false
    end
  end
  
  describe :add do
    it 'accepts attributes or name value pares' do
      Heading.new.add( Attribute.new(:name => 'a', :type => Fixnum)).first.type.should eql(Fixnum)
      Heading.new.add(:name => 'a', :type => Fixnum).first.type.should eql(Fixnum)
    end 
    
    it 'should add return a heading with all the attributes of the supplied heading' do
      Heading.new.add( Attribute.new(:name => 'a', :type => Fixnum)).add(Heading.new(:name => 'b', :type => Fixnum)).should eql(Heading.new(:name => 'a', :type => 1).add(Attribute.new(:name => 'b', :type => Fixnum)))
    end
    
    
    it 'only accepts attributes or name value pares' do
      lambda{ Heading.new.add(:test,:test) }.should raise_error
    end
    
    it 'returns a new instance' do
      h = Heading.new 
      h.add(:name => 'a', :type => Fixnum).should_not eql(h)
    end
  end
  
  describe :[] do
    it 'returns the attribute for the given attribute name' do
      Heading.new.add(:name => 'a', :type => Fixnum)[:a].should eql(Attribute.new(:name => 'a', :type => Fixnum))
    end
  end
  
  describe :rename do
    it 'changes the name of a current attribute' do
      Heading.new.add(:name => 'name', :type => String).rename(:name ,:title).should eql(Heading.new.add(:name => :title,:type => String))
    end
    
    it 'should throw an exception' do
      lambda { Heading.new.add(:name => :name,:type => String).add(:name => :age,:type => Fixnum).rename(:age ,:name) }.should raise_error(ArgumentError)
      lambda { Heading.new.add(:name => :age,:type => Fixnum).rename(:year ,:some_other_year) }.should raise_error(ArgumentError)
    end
  end
  
  
  describe :remove do
    it 'removes given attribute' do
      Heading.new(Attribute.new(:name => 'a', :type => 1)).remove(Attribute.new(:name => 'a', :type => 1)).count.should eql(0)
    end
    
    it 'removes given attribute name' do
      Heading.new(Attribute.new(:name => 'a', :type => 1)).remove(:a).count.should eql(0)
    end
    
    it 'returns a new instance' do
      h = Heading.new Attribute.new(:name => 'a', :type => 1)
      h.remove(Attribute.new(:name => 'a', :type => 1)).should_not eql(h)
    end
  end
  
  
  describe :each do
    it 'iterates over all the attributes in the heading' do
    
      
      count = 0
      Heading.new.add(Attribute.new(:name => 'a', :type => Fixnum)).add(Heading.new(:name => 'b', :type => Fixnum)).each do |attribute|
        count += 1
      end
  
      count.should eql(2)

      
    end
  end
  
  
end
