class NavigationLine
  CLOSING_CHARACTERS = [')', ']', '}', '>']

  def initialize(line)
    previous_characters = []
    line.split("").each do |character|
      if CLOSING_CHARACTERS.include?(character)
        if previous_characters[-1] != matching_open_character(character)
          @is_illegal = true
          @first_illegal_character = character
          break
        else
          previous_characters.pop
        end
      else
        previous_characters << character
      end
    end
  end

  def is_illegal?
    @is_illegal
  end

  def illegal_character_score
    case @first_illegal_character
    when ')'
      3
    when ']'
      57
    when '}'
      1197
    when '>'
      25137
    end
  end

  private

  def matching_open_character(closing_character)
    case closing_character
    when ')'
      '('
    when ']'
      '['
    when '}'
      '{'
    when '>'
      '<'
    end
  end
end

puts File.readlines("10.txt")
         .map { |line| NavigationLine.new(line) }
         .filter(&:is_illegal?)
         .map(&:illegal_character_score)
         .sum

