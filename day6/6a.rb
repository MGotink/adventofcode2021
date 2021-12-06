class Lanternfish
  RESET_AGE = 6
  NEW_SPAWN_AGE = 8

  def initialize(age=8)
    @age = age
  end

  def next_day
    if @age == 0
      [
        Lanternfish.new(RESET_AGE),
        Lanternfish.new(NEW_SPAWN_AGE)
      ]
    else
      [Lanternfish.new(@age - 1)]
    end
  end
end

class Ocean
  def initialize(ages)
    @lanternfish = ages.map { |age| Lanternfish.new(age) }
  end

  def next_day
    @lanternfish = @lanternfish.flat_map(&:next_day)
  end

  def lanternfish_count
    @lanternfish.size
  end
end

ages = File.open("6.txt", &:readline).split(",").map(&:to_i)
ocean = Ocean.new(ages)

80.times do
  ocean.next_day
end

puts ocean.lanternfish_count
