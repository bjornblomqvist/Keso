require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Attribute do


  
  describe :new do
    it 'creates a new attrbute with given name and class' do
      Attribute.new(:name => :age, :type => Fixnum).type.should eql(Fixnum)
      Attribute.new(:name => :age, :type => Fixnum).name.should eql('age')
    end
    
    it 'creates a new attribute when given a symal as name and a value as type' do
      Attribute.new(:name => :age, :type => 1).type.should eql(Fixnum)
      Attribute.new(:name => :age, :type => "ueoau").type.should eql(String)
    end
  end
  
  describe :== do
    it 'should return true when to attributes with the same name and type is compared' do
      (Attribute.new(:name => :age, :type => Fixnum) == Attribute.new(:name => 'age', :type => Fixnum)).should be_true
    end
  end
  
  describe :eql? do
    it 'should return true when to attributes with the same name and type is compared' do
      (Attribute.new(:name => :age, :type => Fixnum).eql?(Attribute.new(:name => 'age', :type => Fixnum))).should be_true
    end
  end
  
  describe :hash do
    it 'should return the same value for attributes that are equal' do
      Attribute.new(:name => :age, :type => Fixnum).hash.should eql(Attribute.new(:name => 'age', :type => Fixnum).hash)
    end
  end
  
  describe :type do
    it 'is a accesor to the type of the attribute' do
      Attribute.new(:name => :age, :type => Fixnum).type.should eql(Fixnum)
    end
  end
  
  describe :name do
    it 'is a accesor to the type of the attribute' do
      Attribute.new(:name => :age, :type => Fixnum).name.should eql('age')
    end
  end
  
end

