def average(array)
  sum = array.sum(0.0)
  size = array.size
  (sum / size)
end

def sum_of_natural_numbers(last)
  last * (last + 1) / 2
end

positions = File.open("7.txt", &:readline).split(",").map(&:to_i)
average = average(positions)
possibilities = [average.floor, average.ceil]

total_fuels = possibilities.map do |average|
  positions.map do |position|
    sum_of_natural_numbers((position - average).abs)
  end.sum
end

puts total_fuels.min
