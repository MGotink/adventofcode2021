PACKET_TYPE_LITERAL_VALUE = 4

def shift_next_n_bits(binary_array, n)
  version = binary_array.shift(n).join.to_i(2)
end

transmission = File.open("16.txt", &:gets).strip
binary_string = transmission.to_i(16).to_s(2)
preferred_length = (binary_string.length.to_f / 8.0).ceil * 8
binary_string = binary_string.rjust(preferred_length, "0")
binary_array = binary_string.chars

versions = []

while binary_array.reject { |bit| bit == "0" }.length > 0
  version = shift_next_n_bits(binary_array, 3)
  versions << version
  type_id = shift_next_n_bits(binary_array, 3)

  if type_id == PACKET_TYPE_LITERAL_VALUE
    has_next = true
    number = 0
    while has_next
      number_part = shift_next_n_bits(binary_array, 5)
      number = (number << 4) | (number_part & 0xF)
      has_next = number_part & 0x10 != 0
    end
  else
    length_type_id = shift_next_n_bits(binary_array, 1)
    if length_type_id == 0
      total_length = shift_next_n_bits(binary_array, 15)
    else
      number_of_sub_packets = shift_next_n_bits(binary_array, 11)
    end
  end
end

puts versions.sum

