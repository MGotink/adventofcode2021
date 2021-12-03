result = File.readlines("2.txt", chomp: true)
  .map { |line| line.split ' ' }
  .map { |line| { command: line[0].to_sym, amount: line[1].to_i } }
  .inject({}) { |hash, line|
    hash[line[:command]] ||= 0
    hash[line[:command]] += line[:amount]
    hash
  }

puts result[:forward] * (result[:down] + -result[:up])

