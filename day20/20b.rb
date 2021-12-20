def print_image(image)
  puts image.map { |line| translate_from_binary(line.join("")) }.join("\n")
end

def translate_to_binary(pixel)
  pixel.gsub(".", "0").gsub("#", "1")
end

def translate_from_binary(number)
  number.gsub("0", ".").gsub("1", "#")
end

input = File.readlines("20.txt", chomp: true)

image_enhancement_algorithm = translate_to_binary(input[0])

runs = 50
buffer = runs * 2
input_image_size = input[2].size
input_image = input[2..-1].map { |line| ["0"] * buffer + translate_to_binary(line).chars + ["0"] * buffer }

buffer.times do
  input_image.unshift(["0"] * (input_image_size + buffer * 2))
  input_image.push(["0"] * (input_image_size + buffer * 2))
end

print_image(input_image)

runs.times do
  min_x = 3
  max_x = input_image[0].size - 3
  min_y = min_x
  max_y = max_x

  output_image = Marshal.load(Marshal.dump(input_image))

  (min_x...max_x).each do |x|
    (min_y...max_y).each do |y|
      line = ""
      line << input_image[y-1][x-1]
      line << input_image[y-1][x]
      line << input_image[y-1][x+1]
      line << input_image[y][x-1]
      line << input_image[y][x]
      line << input_image[y][x+1]
      line << input_image[y+1][x-1]
      line << input_image[y+1][x]
      line << input_image[y+1][x+1]

      number = line.to_i(2)
      pixel = image_enhancement_algorithm[number]

      output_image[y][x] = pixel
    end
  end

  target_pixel = output_image[3][3]
  (0...3).each do |x|
    (0...output_image[0].length).each do |y|
      output_image[y][x] = target_pixel
      output_image[y][-x - 1] = target_pixel
      output_image[x][y] = target_pixel
      output_image[-x - 1][y] = target_pixel
    end
  end

  input_image = output_image

  puts ""
  print_image(output_image)
end

input_image.each do |line|
  line[3] = "."
end
input_image[-7] = ["."] * (input_image_size + buffer * 2)

print_image(input_image)

puts input_image.flatten.count("1")

