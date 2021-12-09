class Entry
  attr_reader :signal_pattern, :output_value

  def initialize(entry)
    signal_pattern, output_value = entry.split(" | ")

    @signal_pattern = SignalPattern.new(signal_pattern)
    @output_value = OutputValue.new(output_value)
  end

  def determine_remaining_digits
    resulting_digits = {}
    resulting_digits[1] = @signal_pattern.find_by_length(2)[0]
    resulting_digits[4] = @signal_pattern.find_by_length(4)[0]
    resulting_digits[7] = @signal_pattern.find_by_length(3)[0]
    resulting_digits[8] = @signal_pattern.find_by_length(7)[0]

    zero_six_and_nine = @signal_pattern.find_by_length(6)
    resulting_digits[6] = determine_match(zero_six_and_nine, resulting_digits[7], 4)
    resulting_digits[9] = determine_match(zero_six_and_nine, resulting_digits[4], 2)
    resulting_digits[0] = (zero_six_and_nine - [resulting_digits[6], resulting_digits[9]])[0]

    two_three_and_five = @signal_pattern.find_by_length(5)
    resulting_digits[5] = determine_match(two_three_and_five, resulting_digits[6], 0)
    resulting_digits[2] = determine_match(two_three_and_five, resulting_digits[5], 2)
    resulting_digits[3] = (two_three_and_five - [resulting_digits[5], resulting_digits[2]])[0]

    resulting_digits = resulting_digits.invert

    @output_value.digits.map { |digit| resulting_digits[digit].to_s }.join.to_i
  end

  private

  def determine_match(input_numbers, subtract_digit, expected_outcome)
    if (input_numbers[0] - subtract_digit).length == expected_outcome || (subtract_digit - input_numbers[0]).length == expected_outcome
      input_numbers[0]
    elsif (input_numbers[1] - subtract_digit).length == expected_outcome || (subtract_digit - input_numbers[1]).length == expected_outcome
      input_numbers[1]
    else
      input_numbers[2]
    end
  end
end

class SignalPattern
  attr_reader :digits

  def initialize(signal_pattern)
    @digits = signal_pattern.split.map { |digit| Digit.new(digit) }
  end

  def find_by_length(length)
    @digits.select { |digit| digit.number_of_segments == length }
  end
end

class OutputValue < SignalPattern; end

class Digit
  attr_reader :value

  def initialize(value)
    @value = value.chars.sort
  end

  def number_of_segments
    @value.size
  end

  def -(other)
    @value - other.value
  end

  def ==(other)
    @value == other.value
  end

  def eql?(other)
    self == other
  end

  def hash
    @value.hash
  end
end

entries = File.readlines("8.txt")
  .map { |entry| Entry.new(entry) }

puts entries.map(&:determine_remaining_digits).sum
