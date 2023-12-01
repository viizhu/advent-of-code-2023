class PuzzleOne
  calibration = File.readlines('01-input.txt').map(&:to_s)

  def self.find_sum(inputs)
    sum = 0
    regex = %r{(0|1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)}
    regex_reverse = %r{(0|1|2|3|4|5|6|7|8|9|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)}
    inputs.each do |input|
      first = input.scan(regex).first
      x = [] << parse_num(first[0])
      second = input.reverse.scan(regex_reverse).first
      y = [] << parse_num(second[0])

      number = x.concat(y)
      sum += number.join.to_i
    end

    puts sum
  end

  def self.parse_num(num)
    case num
    when 'one', 'eno'
      1
    when 'two', 'owt'
      2
    when 'three', 'eerht'
      3
    when 'four', 'ruof'
      4
    when 'five', 'evif'
      5
    when 'six', 'xis'
      6
    when 'seven', 'neves'
      7
    when 'eight', 'thgie'
      8
    when 'nine', 'enin'
      9
    else
      num.to_i
    end
  end

  find_sum(calibration)
end
