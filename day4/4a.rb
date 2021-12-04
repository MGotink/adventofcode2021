class Square
  attr_reader :number, :marked

  def initialize(number)
    @number = number
    @marked = false
  end

  def mark(number)
    if @number == number
      @marked = true
    end
  end

  def unmarked
    !@marked
  end
end

class Board
  def initialize(numbers)
    @squares = numbers.map { |number| Square.new(number) }
  end

  def mark(number)
    @squares.each { |square| square.mark(number) }
  end

  def won?
    won = @squares.each_slice(5).map do |row|
      row.all?(&:marked)
    end.any?

    won || @squares.each_slice(5).to_a.transpose.map do |column|
      column.all?(&:marked)
    end.any?
  end

  def sum_unmarked_numbers
    @squares.filter(&:unmarked).map(&:number).sum
  end
end

class BingoGame
  def initialize(draws, boards)
    @draws = draws
    @boards = boards
  end

  def play
    last_number = nil

    @draws.each do |draw|
      last_number = draw
      @boards.each { |board| board.mark(draw) }

      break if @boards.any?(&:won?)
    end

    print_score(@boards.find(&:won?), last_number)
  end

  def print_score(board, last_number)
    puts board.sum_unmarked_numbers * last_number
  end
end

lines = File.readlines("4.txt")
draws = lines[0].split(",").map(&:to_i)
boards = lines.drop(2).flat_map(&:split).map(&:to_i).each_slice(25).map { |numbers| Board.new(numbers) }

game = BingoGame.new(draws, boards)
game.play
