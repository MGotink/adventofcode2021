lines = File.readlines("14.txt", chomp: true)

polymer_template = lines.delete_at(0)
lines.delete_at(0)

pair_insertions = lines.map { |line| line.split(" -> ") }
                       .each { |pair| pair[1] = pair[0][0] + pair[1] + pair[0][1] }

10.times do |n|
  polymer_pairs = polymer_template.chars.each_cons(2).map(&:join)
  pair_insertions.each do |pair_insertion|
    polymer_pairs.filter { |polymer_pair| polymer_pair.length == 2 }
                 .each { |polymer_pair| polymer_pair.gsub!(*pair_insertion) }
  end
  polymer_template = polymer_pairs.inject { |template, pair| template[0..-2] + pair }
end

counts = polymer_template.chars.tally.sort_by { |_, count| count }
min = counts[0][1]
max = counts[-1][1]

puts max - min

