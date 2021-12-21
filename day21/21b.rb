positions = File.readlines("21.txt", chomp: true)
                .map { |line| line.match(/: (\d+)/)[1].to_i }

@dice = [1, 2, 3]
@cache = {}

def play(current_position, other_position, current_score, other_score)
  cache_key = [current_position, other_position, current_score, other_score].to_s
  if @cache[cache_key]
    return @cache[cache_key]
  end

  if current_score >= 21
    score = [1, 0]
  elsif other_score >= 21
    score = [0, 1]
  else
    score = [0, 0]
    @dice.product(@dice, @dice).each do |rolls|
      new_current_position = (current_position + rolls.sum - 1) % 10 + 1
      new_current_score = current_score + new_current_position
      p2_wins, p1_wins = play(other_position, new_current_position, other_score, new_current_score)
      score = [score[0] + p1_wins, score[1] + p2_wins]
    end
  end

  @cache[cache_key] = score

  score
end

puts(play(positions[0], positions[1], 0, 0).max)

