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
    x_values = @from.x.step(@to.x, @from.x <= @to.x ? 1 : -1).to_a
    y_values = @from.y.step(@to.y, @from.y <= @to.y ? 1 : -1).to_a

    coordinate_array = x_values.product(y_values)

    if is_diagonal?
      diagonal_coordinates(coordinate_array, x_values.size)
    else
      coordinate_array
    end
  end

  private

  def diagonal_coordinates(coordinate_array, count)
    coordinate_grid = coordinate_array.each_slice(count).to_a
    (0...count).collect { |i| coordinate_grid[i][i] }
  end
end

class OceanFloor
  def initialize(input)
    @vent_lines = input.map { |line| VentLine.new(line) }
  end

  def vents
    @vent_lines.flat_map(&:coordinates).tally
  end

  def dangerous_vent_count
    vents.filter { |_coordinate, count| count > 1 }.size
  end
end

input_lines = File.readlines("5.txt")
ocean_floor = OceanFloor.new(input_lines)

puts ocean_floor.dangerous_vent_count
