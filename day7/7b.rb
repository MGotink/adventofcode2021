def average(array)
  sum = array.sum(0.0)
  size = array.size
  (sum / size).round
end

def sum_of_natural_numbers(last)
  last * (last + 1) / 2
end

positions = File.open("7.txt", &:readline).split(",").map(&:to_i)
average = average(positions)
possibilities = [average - 1, average, average + 1]

total_fuels = possibilities.map do |average|
  positions.map do |position|
    sum_of_natural_numbers((position - average).abs)
  end.sum
end

puts total_fuels.min
