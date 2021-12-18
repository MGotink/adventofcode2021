input = File.open("17.txt", &:gets)

target_x = input.match(/x=(-?\d+)\.\.(-?\d+)/)[1..2].map(&:to_i)
target_y = input.match(/y=(-?\d+)\.\.(-?\d+)/)[1..2].map(&:to_i)

def calculate_trajectory(velocity_x, velocity_y, target_x, target_y)
  original_velocity = [velocity_x, velocity_y]
  x = 0
  y = 0
  max_y = -100
  i = 0
  inside = false
  passed = false

  while !inside && !passed
    x += velocity_x
    y += velocity_y

    max_y = [max_y, y].max

    if velocity_x > 0
      velocity_x -= 1
    elsif velocity_x < 0
      velocity_x += 1
    end

    velocity_y -= 1

    inside = (x >= target_x[0] && x <= target_x[1]) && (y <= target_y[1] && y >= target_y[0])
    passed = x > target_x[1] || y < target_y[0]

    i += 1
  end

  passed ? nil : original_velocity << max_y
end

found = (2..target_x[1]).flat_map do |velocity_x|
  (target_y[0]..(-target_y[0] * 2)).map do |velocity_y|
    calculate_trajectory(velocity_x, velocity_y, target_x, target_y)
  end
end

puts found.compact.size

