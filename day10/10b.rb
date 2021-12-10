class NavigationLine
  CLOSING_CHARACTERS = [')', ']', '}', '>']
  CHARACTER_MAP = {'(' => ')', '[' => ']', '{' => '}', '<' => '>'}
  CHARACTER_SCORES = {'(' => 1, '[' => 2, '{' => 3, '<' => 4}

  def initialize(line)
    previous_characters = []
    line.split("").each do |character|
      if CLOSING_CHARACTERS.include?(character)
        if previous_characters[-1] != matching_open_character(character)
          @is_illegal = true
          break
        else
          previous_characters.pop
        end
      else
        previous_characters << character
      end
    end

    @missing_closing_characters = previous_characters.reverse
  end

  def is_legal?
    !@is_illegal
  end

  def autocomplete_character_score
    @missing_closing_characters.map { |character| CHARACTER_SCORES[character] }
                               .inject { |sum, character| sum * 5 + character }
  end

  private

  def matching_open_character(closing_character)
    CHARACTER_MAP.invert[closing_character]
  end

  def matching_close_character(opening_character)
    CHARACTER_MAP[opening_character]
  end
end

scores = File.readlines("10.txt", chomp: true)
             .map { |line| NavigationLine.new(line) }
             .filter(&:is_legal?)
             .map(&:autocomplete_character_score)

puts scores.sort[scores.size / 2]

