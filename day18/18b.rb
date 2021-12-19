numbers = File.readlines("18.txt", chomp: true)
              .map { |line| eval(line) }

def reduce(number)
  number, _left, _right, changed = explode(number)
  split(number, changed)
end

def explode(pair, previous_pair = nil, left = nil, right = nil, changed = false, level = 0, index = 0, next_pair = nil)
  if right && right[:on_start] && pair[0].class == Integer
    pair[0] += right[:value]
    right = nil
  end

  if !changed && level == 4
    if left && left[:pair]
      left[:pair][left[:index]] += pair[0]
    end
    changed = true
    on_start = index == 1 && next_pair.class != Integer
    skip_first = next_pair.class == Integer && index == 1
    if index == 1 && next_pair.class != Integer
      fill_index = 0
    else
      fill_index = next_pair.class == Integer ? 1 : 0
    end
    right = {value: pair[1], index: index, on_start: on_start, fill_index: fill_index, skip_first: skip_first}
    pair = 0
    return [pair, left, right, changed]
  else
    i = 0
    previous_next_pair = next_pair
    while pair.class == Array && i < pair.length
      if pair[i].class == Array
        if i == 0
          next_pair = pair[1]
        else
          next_pair = previous_next_pair
        end
        new_pair, left, right, changed = explode(pair[i], pair, left, right, changed, level + 1, i, next_pair)
        pair[i] = new_pair
      else
        left = {pair: pair, index: i}
      end
      i += 1
    end
  end

  if right && right[:skip_first]
    right[:skip_first] = false
  elsif right && !right[:on_start] && !right[:skip_first] && pair[right[:fill_index]].class == Integer
    pair[right[:fill_index]] += right[:value]
    right = nil
  end

  [pair, left, right, changed]
end

def split(pair_or_number, changed = false)
  if changed
    [pair_or_number, changed]
  elsif pair_or_number.class == Integer && pair_or_number >= 10
    half_number = pair_or_number.to_f / 2
    pair_or_number = [half_number.floor, half_number.ceil]
    changed = true
  elsif pair_or_number.class == Integer && pair_or_number >= 10
    half_number = pair_or_number.to_f / 2
    pair_or_number = [half_number.floor, half_number.ceil]
    changed = true
  else
    i = 0
    while pair_or_number.class == Array && i < pair_or_number.length
      new_pair_or_number, changed = split(pair_or_number[i], changed)
      pair_or_number[i] = new_pair_or_number
      i += 1
    end
  end

  [pair_or_number, changed]
end

def add(number1, number2)
  [] << number1 << number2
end

def calculate_magnitude(number, factor = nil)
  if number.class == Integer
    return number
  else
    calculate_magnitude(number[0]) * 3 + calculate_magnitude(number[1]) * 2
  end
end

combinations = numbers.product(numbers)
                      .filter { |combination| combination[0] != combination[1] }

magnitudes = combinations.map do |numbers|
  resulting_number = Marshal.load(Marshal.dump(numbers[0]))
  resulting_number = add(resulting_number, Marshal.load(Marshal.dump(numbers[1])))
  loop do
    resulting_number, changed = reduce(resulting_number)
    break if !changed
  end

  calculate_magnitude(resulting_number)
end

puts magnitudes.max

