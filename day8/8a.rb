puts File.readlines("8.txt")
         .map { |entry| entry.split(" | ") }
         .map { |entry| entry[1] }
         .flat_map(&:split)
         .filter { |digit| [2, 4, 3, 7].include?(digit.length) }
         .count
