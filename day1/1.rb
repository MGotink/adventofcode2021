previous = nil
increments = 0

puts File.readlines("1.txt", chomp: true)
  .map {|line| line.to_i }
  .each_cons(2)
  .count {|e| e[0] < e[1]}

#File.readlines("1.txt", chomp: true).each do |line|
#  current = line.to_i
#
#  if previous.nil?
#    change = "(N/A - no previous measurement)"
#  elsif current > previous
#    change = "(increased)"
#    increments += 1
#  elsif current < previous
#    change = "(decreased)"
#  else
#    change = "(equal)"
#  end
#
#  previous = current
#
#  puts "#{current} #{change}"
#end
#
#puts increments

