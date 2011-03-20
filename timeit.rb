

old_puts = puts
@tab_count = 0

def puts object
  super "\t"*@tab_count + object.to_s
end

def timeit name, &block
  
  @tab_count += 1
  start_time = Time.now
  puts ""
  puts "(#{name}) runing"
  yield block
  puts "(#{name}) total time: #{Time.now - start_time}"
  puts ""
  
  @tab_count -= 1
end

load 'timeit/relation_bench.rb'





