sum = 0
calibration = File.readlines('01-input.txt').map(&:to_s)

calibration.each do |input|
  number = input.scan(/\d+/).join('')
  if number.length == 1
    number = number.concat(number)
  else
    number = number.chars.first.concat(number.chars.last)
  end

  sum += number.to_i
end

puts sum
