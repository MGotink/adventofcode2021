class DeterministicDice
  attr_reader :rolls

  def initialize(sides)
    @sides = sides
    @number = sides - 1
    @rolls = 0
  end

  def roll(times)
    @rolls += times
    times.times.collect { next_number }.sum
  end

  private
  def next_number
    @number = (@number + 1) % @sides
    @number + 1
  end
end

class Player
  attr_reader :position, :score

  def initialize(line)
    @position = line.match(/: (\d+)/)[1].to_i
    @score = 0
  end

  def advance(number)
    @position = (((@position - 1) + number) % 10) + 1
    @score += @position
  end
end

players = File.readlines("21.txt", chomp: true)
                .map { |line| Player.new(line) }

dice = DeterministicDice.new(100)

won = nil
while !won do
  players.each_with_index do |player, i|
    number = dice.roll(3)

    player.advance(number)

    if player.score >= 1000
      won = i
      break
    end
  end
end

lost_player = players[won == 1 ? 0 : 1]

puts lost_player.score * dice.rolls

