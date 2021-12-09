array = File.readlines("9.txt", chomp: true)
            .map { |line| line.split("").map(&:to_i) }
            .map { |line| [9] + line + [9] }

extra_line = [9] * array[0].length
array = [extra_line] + array + [extra_line]

low_points = []
(1...array.length - 1).each do |i|
  (1...array[i].length - 1).each do |j|
    number = array[i][j]
    if array[i-1][j] <= number
      next
    elsif array[i+1][j] <= number
      next
    elsif array[i][j-1] <= number
      next
    elsif array[i][j+1] <= number
      next
    end
    low_points << number
  end
end

puts low_points.map(&:succ).sum

