PACKET_TYPE_LITERAL_VALUE = 4

def shift_next_n_bits(binary_array, n)
  version = binary_array.shift(n).join.to_i(2)
end

transmission = File.open("16.txt", &:gets).strip
binary_string = transmission.to_i(16).to_s(2)
preferred_length = (binary_string.length.to_f / 8.0).ceil * 8
binary_string = binary_string.rjust(preferred_length, "0")
binary_array = binary_string.chars

def parse(binary_array)
  version = shift_next_n_bits(binary_array, 3)
  type_id = shift_next_n_bits(binary_array, 3)

  if type_id == PACKET_TYPE_LITERAL_VALUE
    has_next = true
    number = 0
    while has_next
      number_part = shift_next_n_bits(binary_array, 5)
      number = (number << 4) | (number_part & 0xF)
      has_next = number_part & 0x10 != 0
    end
    number
  else
    length_type_id = shift_next_n_bits(binary_array, 1)
    if length_type_id == 0
      total_length = shift_next_n_bits(binary_array, 15)
      start_length = binary_array.length
      numbers = []
      while start_length - binary_array.length < total_length
        numbers << parse(binary_array)
      end
      execute_operator(type_id, numbers)
    else
      number_of_sub_packets = shift_next_n_bits(binary_array, 11)
      numbers = []
      while numbers.length < number_of_sub_packets
        numbers << parse(binary_array)
      end
      execute_operator(type_id, numbers)
    end
  end
end

def execute_operator(type_id, numbers)
  case type_id
  when 0
    numbers.inject(:+)
  when 1
    numbers.inject(:*)
  when 2
    numbers.min
  when 3
    numbers.max
  when 5
    numbers[0] > numbers[1] ? 1 : 0
  when 6
    numbers[0] < numbers[1] ? 1 : 0
  when 7
    numbers[0] == numbers[1] ? 1: 0
  end
end

puts parse(binary_array)

