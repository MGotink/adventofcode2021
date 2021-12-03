def find_value(lines, inverted=false)
  comparison_method = inverted ? :<= : :>=
  default_value = inverted ? "0" : "1"
  other_value = inverted ? "1" : "0"

  for index in 0...lines[0].size do
    count = lines.transpose[index].count(default_value)

    matching_bit = (count * 2).send(comparison_method, lines.size) ? default_value : other_value

    lines = lines.filter { |line| line[index] == matching_bit || lines.size == 1 }
  end

  lines[0].join.to_i(2)
end

lines = File.readlines("3.txt", chomp: true)
  .map { |line| line.split("") }

oxygen_generator_rating = find_value(lines)

co2_scrubber_rating = find_value(lines, true)

puts oxygen_generator_rating * co2_scrubber_rating

