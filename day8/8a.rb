class Entry
  attr_reader :signal_pattern, :output_value

  def initialize(entry)
    signal_pattern, output_value = entry.split(" | ")

    @signal_pattern = SignalPattern.new(signal_pattern)
    @output_value = OutputValue.new(output_value)
  end
end

class SignalPattern
  attr_reader :digits

  def initialize(signal_pattern)
    @digits = signal_pattern.split.map { |digit| Digit.new(digit) }
  end
end

class OutputValue
  attr_reader :digits

  def initialize(output_value)
    @digits = output_value.split.map { |digit| Digit.new(digit) }
  end
end

class Digit
  def initialize(value)
    @value = value
  end

  def number_of_segments
    @value.length
  end
end

puts File.readlines("8.txt")
  .map { |entry| Entry.new(entry) }
  .map(&:output_value)
  .flat_map(&:digits)
  .filter { |digit| [2, 4, 3, 7].include?(digit.number_of_segments) }
  .count

