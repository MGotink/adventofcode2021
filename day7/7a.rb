def median(array)
  sorted = array.sort
  length = sorted.length
  (sorted[(length - 1) / 2] + sorted[length / 2]) / 2.0
end

positions = File.open("7.txt", &:readline).split(",").map(&:to_i)
median = median(positions).to_i
total_fuel = positions.map do |position|
  (position - median).abs
end.sum

puts total_fuel
