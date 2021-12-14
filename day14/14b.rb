lines = File.readlines("14.txt", chomp: true)

polymer_template = lines.delete_at(0)
lines.delete_at(0)

pair_insertions = lines.map { |line| line.split(" -> ") }
                       .to_h

pairs = Hash.new(0)
elements = Hash.new(0)

polymer_template.chars[0..-2].each.with_index do |char, i|
  pairs[polymer_template[i..i+1]] += 1
  elements[char] += 1
end
elements[polymer_template[-1]] += 1

40.times do |n|
  pairs.dup.each do |pair, count|
    new_element = pair_insertions[pair]
    elements[new_element] += count
    pairs[pair] -= count
    pairs[pair[0] + new_element] += count
    pairs[new_element + pair[1]] += count
  end
end

min = elements.values.min
max = elements.values.max

puts max - min

