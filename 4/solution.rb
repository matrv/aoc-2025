# frozen_string_literal: true

content = File.read('input.txt')
content_array = content.split("\n").map(&:chars)
counter = 0

content_array.each_with_index do |line, i|
  line.each_with_index do |char, j|
    next if char != '@'

    neighbours = 0
    neighbours += 1 if i.positive? && j.positive? && content_array[i - 1][j - 1] == '@'
    neighbours += 1 if i.positive? && content_array[i - 1][j] == '@'
    neighbours += 1 if i.positive? && j < line.length - 1 && content_array[i - 1][j + 1] == '@'
    neighbours += 1 if j.positive? && content_array[i][j - 1] == '@'
    neighbours += 1 if j < line.length - 1 && content_array[i][j + 1] == '@'
    neighbours += 1 if i < content_array.length - 1 && j.positive? && content_array[i + 1][j - 1] == '@'
    neighbours += 1 if i < content_array.length - 1 && content_array[i + 1][j] == '@'
    neighbours += 1 if i < content_array.length - 1 && j < line.length - 1 && content_array[i + 1][j + 1] == '@'
    counter += 1  if neighbours < 4
  end
end

puts "Part 1 answer: #{counter}"
counter = 0

while true
  local_counter = 0
  content_array.each_with_index do |line, i|
    line.each_with_index do |char, j|
      next if char != '@'

      neighbours = 0
      neighbours += 1 if i.positive? && j.positive? && content_array[i - 1][j - 1] == '@'
      neighbours += 1 if i.positive? && content_array[i - 1][j] == '@'
      neighbours += 1 if i.positive? && j < line.length - 1 && content_array[i - 1][j + 1] == '@'
      neighbours += 1 if j.positive? && content_array[i][j - 1] == '@'
      neighbours += 1 if j < line.length - 1 && content_array[i][j + 1] == '@'
      neighbours += 1 if i < content_array.length - 1 && j.positive? && content_array[i + 1][j - 1] == '@'
      neighbours += 1 if i < content_array.length - 1 && content_array[i + 1][j] == '@'
      neighbours += 1 if i < content_array.length - 1 && j < line.length - 1 && content_array[i + 1][j + 1] == '@'
      local_counter += 1 and content_array[i][j] = 'x' if neighbours < 4
    end
  end
  counter += local_counter
  break if local_counter == 0
end

puts "Part 2 answer: #{counter}"
