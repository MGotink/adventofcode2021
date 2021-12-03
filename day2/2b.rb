def update_result(result, line)
  case line[:command]
  when :down
    result[:aim] += line[:amount]
  when :up
    result[:aim] -= line[:amount]
  when :forward
    result[:position] += line[:amount]
    result[:depth] += result[:aim] * line[:amount]
  end
  
  result
end

result = File.readlines("2.txt", chomp: true)
  .map { |line| line.split ' ' }
  .map { |line| { command: line[0].to_sym, amount: line[1].to_i } }
  .inject({depth: 0, position: 0, aim: 0}) { |result, line| update_result(result, line) } 

puts result[:position] * result[:depth]

