gamma = File.readlines("3.txt", chomp: true)
  .map { |line| line.split("") }
  .transpose
  .map { |bits| bits.count("1") }
  .map { |count| count > 500 ? "1" : "0" }
  .join
  .to_i(2)

epsilon = 0xFFF - gamma

puts epsilon * gamma

