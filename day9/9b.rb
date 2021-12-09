class Location
  attr_reader :x, :y, :height

  def initialize(x, y, height)
    @x = x
    @y = y
    @height = height
  end

  def valid?
    @height < 9
  end

  def ==(other)
    @x == other.x && @y == other.y && @height == other.height
  end

  def eql?(other)
    self == other
  end

  def hash
    [@x, @y, @height].hash
  end
end

array = File.readlines("9.txt", chomp: true)
            .map { |line| line.split("").map(&:to_i) }
            .map { |line| [9] + line + [9] }

extra_line = [9] * array[0].length
array = [extra_line] + array + [extra_line]

array = array.map.with_index do |line, y|
  line.map.with_index do |height, x|
    Location.new(x, y, height)
  end
end

basins = []
(1...array.length - 1).each do |y|
  (1...array[y].length - 1).each do |x|
    location = array[y][x]
    north_location = array[y-1][x]
    east_location = array[y][x-1]

    if location.valid?
      found_basins = []
      basins.each do |basin|
        if basin.include?(east_location) || basin.include?(north_location)
          basin << location
          found_basins << basin
        end
      end

      if found_basins.empty?
        basins << [location]
      end
      if found_basins.size > 1
        new_basin = []
        found_basins.each do |basin|
          basins.delete(basin)
          new_basin |= basin
        end
        basins << new_basin
      end
    end
  end
end

puts basins.map(&:size).sort.reverse[0..2].inject(:*)

