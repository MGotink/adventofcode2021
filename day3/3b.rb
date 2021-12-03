lines = File.readlines("3.txt", chomp: true)
  .map { |line| line.split("") }

oxygen_lines = lines.clone
for index in 0...12 do
  count = oxygen_lines
    .map { |bits| bits[index] }
    .count("1")

  most_common_bit = count * 2 >= oxygen_lines.size ? "1" : "0"

  oxygen_lines
    .filter! { |line| line[index] == most_common_bit }
end

oxygen_generator_rating = oxygen_lines[0].join.to_i(2)

co2_lines = lines.clone
for index in 0...12 do
  count = co2_lines
    .map { |bits| bits[index] }
    .count("0")

  least_common_bit = count * 2 <= co2_lines.size ? "0" : "1"

  co2_lines
    .filter! { |line| line[index] == least_common_bit || co2_lines.size == 1 }
end

co2_scrubber_rating = co2_lines[0].join.to_i(2)

puts oxygen_generator_rating * co2_scrubber_rating

