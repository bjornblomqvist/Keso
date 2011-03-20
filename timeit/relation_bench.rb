require './lib/keso.rb'


timeit "Tuple" do
  
  timeit "Create 1000 tuples" do
    
    r = []
    
    1000.times do |i|
     r << Tuple.new({:name => 'Emma',:age => i})
    end
  end
  
  timeit "Create 20000 tuples" do

     r = []

     20000.times do |i|
      r << Tuple.new({:name => 'Emma',:age => i})
     end
   end
  
end


timeit "ImmutableSet" do
  
  timeit "Add 1000 tuples" do
    
    iset = ImmutableSet.new
    
    1000.times do |i|
      iset = iset.add(Tuple.new({:name => 'Emma',:age => i})) 
    end
    
    iset.count
    
  end
  
  timeit "Add 2000 tuples" do
    
    iset = ImmutableSet.new
    
    2000.times do |i|
      iset = iset.add(Tuple.new({:name => 'Emma',:age => i})) 
    end
    
    iset.count
    
  end
  
  timeit "Add 20000 tuples" do
    
    iset = ImmutableSet.new
    
    20000.times do |i|
      iset = iset.add(Tuple.new({:name => 'Emma',:age => i})) 
    end
    
    iset.count
    
  end
  
end


timeit "Relation" do
  
  timeit "Adding 1000 tuples" do
    
    r = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))
    
    1000.times do |i|
     r = r.add(Tuple.new({:name => 'Emma',:age => i})) 
    end
    
    r.count
     
  end
  
  timeit "Adding 2000 tuples" do
    
    r = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))
    
    2000.times do |i|
     r = r.add(Tuple.new({:name => 'Emma',:age => i})) 
    end
    
    r.count
     
  end
  
  timeit "Adding 20000 tuples" do
    
    r = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))
    
    20000.times do |i|
     r = r.add(Tuple.new({:name => 'Emma',:age => i})) 
    end
    
    r.count
     
  end
  
  timeit "Adding 20000 tuples as one array" do
    
    r = Relation.new(Tuple.new({:name => 'Bjorn',:age => 29}))
    a = []
    
    20000.times do |i|
     a << Tuple.new({:name => 'Emma',:age => i})
    end
    
    r.add(a)
    
    r.count
    
  end
  
end




