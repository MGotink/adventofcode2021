class EmptyCell
  def increase_energy
  end

  def check_energy
  end

  def neighbour_flashed
  end

  def energy
    0
  end

  def to_s
    ""
  end
end

class Octopus
  attr_reader :energy

  def initialize(energy)
    @energy = energy
    @neighbours = []
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

500.times do |step|
  octopuses.each(&:increase_energy).each(&:check_energy)
  puts octopuses.map(&:to_s).each_slice(slice_size).map(&:join)
  if octopuses.map(&:energy).sum == 0
    puts "#{step + 1}"
    break
  end
end

