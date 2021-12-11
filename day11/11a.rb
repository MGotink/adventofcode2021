class EmptyCell
  def increase_energy
  end

  def check_energy
  end

  def neighbour_flashed
  end

  def flash_count
    0
  end

  def to_s
    ""
  end
end

class Octopus
  attr_reader :flash_count

  def initialize(energy)
    @energy = energy
    @neighbours = []
    @flash_count = 0
  end

  def add_neighbour(neighbour)
    @neighbours << neighbour
  end

  def increase_energy
    @energy += 1
    @flashed = false
  end

  def check_energy
    if @energy > 9
      @flashed = true
      @flash_count += 1
      @energy = 0

      @neighbours.each(&:neighbour_flashed)
    end
  end

  def neighbour_flashed
    if !@flashed
      increase_energy
      check_energy
    end
  end

  def to_s
    if @flashed
      "\e[32m#{@energy}\e[0m"
    else
      @energy
    end
  end
end

octopuses = File.readlines("11.txt", chomp: true)
                .map do |line|
                  line.split("")
                      .map(&:to_i)
                      .map { |energy| Octopus.new(energy) }
                      .unshift(EmptyCell.new)
                      .push(EmptyCell.new)
                end

octopuses.unshift([EmptyCell.new] * octopuses[0].length)
         .push([EmptyCell.new] * octopuses[0].length)

(1...octopuses.length - 1).each do |i|
  (1...octopuses[i].length - 1).each do |j|
    octopus = octopuses[i][j]
    octopus.add_neighbour(octopuses[i - 1][j - 1])
    octopus.add_neighbour(octopuses[i - 1][j])
    octopus.add_neighbour(octopuses[i - 1][j + 1])
    octopus.add_neighbour(octopuses[i][j - 1])
    octopus.add_neighbour(octopuses[i][j + 1])
    octopus.add_neighbour(octopuses[i + 1][j - 1])
    octopus.add_neighbour(octopuses[i + 1][j])
    octopus.add_neighbour(octopuses[i + 1][j + 1])
  end
end

slice_size = octopuses[0].length
octopuses = octopuses.flatten

100.times do
  octopuses.each(&:increase_energy).each(&:check_energy)
  puts octopuses.map(&:to_s).each_slice(slice_size).map(&:join)
end

puts octopuses.map(&:flash_count).sum

