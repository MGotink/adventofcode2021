puts File.readlines("1.txt", chomp: true)
  .map {|line| line.to_i }
  .each_cons(3)
  .map(&:sum)
  .each_cons(2)
  .count {|e| e[0] < e[1]}

