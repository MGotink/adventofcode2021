Fold = Struct.new(:direction, :line)
Position = Struct.new(:x, :y)

positions = []
folds = []

File.readlines("13.txt", chomp: true)
    .each do |line|
      case line
      when /\d+,\d+/
        positions << Position.new(*line.split(",").map(&:to_i))
      when /fold along [x|y]=\d+/
        match = line.match(/fold along ([x|y])=(\d+)/)
        folds << Fold.new(match[1], match[2].to_i)
      end
    end

def fold_paper(positions, fold)
  positions.delete_if { |position| position[fold.direction] == fold.line }

  positions, positions_to_fold = positions.partition { |position| position[fold.direction] < fold.line}
  positions_to_fold.each do |position|
    position[fold.direction] = (fold.line * 2) - (position[fold.direction])
  end

  positions.concat(positions_to_fold).uniq!
end

def print_result(positions)
  max_x = positions.map(&:x).max
  max_y = positions.map(&:y).max

  matrix = Array.new(max_y + 1) { Array.new(max_x + 1, " ") }

  positions.each do |position|
    matrix[position.y][position.x] = "#"
  end

  puts matrix.map(&:join)
end

folds.each do |fold|
  positions = fold_paper(positions, fold)
end

print_result(positions)

