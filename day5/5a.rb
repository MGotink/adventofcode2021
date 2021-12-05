class Coordinate
  attr_reader :x, :y

  def initialize(coordinate)
    @x, @y = coordinate.split(",").map(&:to_i)
  end
end

class VentLine
  def initialize(line)
    @from, @to = line.split(" -> ").map { |coordinate| Coordinate.new(coordinate) }
  end

  def is_diagonal?
    @from.x != @to.x && @from.y != @to.y
  end

  def coordinates
    x_range = Range.new(*[@from.x, @to.x].sort)
    y_range = Range.new(*[@from.y, @to.y].sort)
    x_range.to_a.product(y_range.to_a)
  end
end

class OceanFloor
  def initialize(input)
    @vent_lines = input.map { |line| VentLine.new(line) }
    @vent_lines.delete_if(&:is_diagonal?)
  end

  def vents
    @vent_lines.flat_map(&:coordinates).tally
  end

  def dangerous_vent_count
    vents.delete_if { |_coordinate, count| count < 2 }.size
  end
end

input_lines = File.readlines("5.txt")
ocean_floor = OceanFloor.new(input_lines)

puts ocean_floor.dangerous_vent_count
