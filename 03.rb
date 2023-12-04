require 'matrix'

class Puzzle3
  attr_reader :numbers, :symbols, :matrix, :part_locations, :temp_val

  def initialize
    @numbers = []
    @symbols = []
    @matrix = nil
    @part_locations = []
    @temp_val = []
  end

  def create_matrix(data)
    arr = []
    data.each_index do |index|
      arr[index] = data[index].split('')
    end
    @matrix = Matrix.build(arr.length, arr[0].length) { |row, col| arr[row][col] }
    @matrix.map!(&:chomp)
  end

  # Part 1
  def check_positions(data)
    calculate_part_index(data)
    puts "symbols: #{@symbols.count}"

    @symbols.each_with_index do |s, i|
      left_col = s[1] - 1
      center_col = s[1]
      right_col = s[1] + 1

      top_row = s[0] - 1
      center_row = s[0]
      bottom_row = s[0] + 1

      line_match(top_row, left_col, center_col, right_col)
      line_match(center_row, left_col, center_col, right_col)
      line_match(bottom_row, left_col, center_col, right_col)
    end

    @numbers = @numbers
    puts "numbers sum: #{@numbers.sum}"
  end

  def line_match(row, left_col, center, right_col)
    if @matrix[row, center].match(/[0-9]/)
      calculate_center(row, center, @matrix[row, center])
    elsif !@matrix[row, center].match(/[0-9]/) && @matrix[row, right_col].match(/[0-9]/) &&  @matrix[row, left_col].match(/[0-9]/)
      calculate_right(row, right_col, @matrix[row, right_col])
      calculate_left(row, left_col, @matrix[row, left_col])
    elsif !@matrix[row, center].match(/[0-9]/) &&  !@matrix[row, left_col].match(/[0-9]/) && @matrix[row, right_col].match(/[0-9]/)
      calculate_right(row, right_col, @matrix[row, right_col])
    elsif !@matrix[row, center].match(/[0-9]/) && !@matrix[row, right_col].match(/[0-9]/) &&  @matrix[row, left_col].match(/[0-9]/)
      calculate_left(row, left_col, @matrix[row, left_col])
    end
  end

  def calculate_center(row, col, val)
    l = 1
    loop do
      if @matrix[row, col - l].match(/[0-9]/) && col - l >= 0
        val = @matrix[row, col - l].to_s + val.to_s
        l += 1
      else
        break
      end
    end

    r = 1
    loop do
      if @matrix[row, col + r].match(/[0-9]/) && col
        val = val.to_s + @matrix[row, col + r].to_s
        r += 1
      else
        break
      end
    end

    @numbers << val.to_i
  end

  def calculate_left(row, col, val)
    l = 1
    loop do
      if @matrix[row, col - l].match(/[0-9]/) && col - l >= 0
        val = @matrix[row, col - l].to_s + val.to_s
        l += 1
      else
        break
      end
    end

    @numbers << val.to_i
  end

  def calculate_right(row, col, val)
    r = 1
    loop do
      if @matrix[row, col + r].match(/[0-9]/) && col
        val = val.to_s + @matrix[row, col + r].to_s
        r += 1
      else
        break
      end
    end

    @numbers << val.to_i
  end

  def calculate_part_index(data)
    create_matrix(data)
    @matrix.each_with_index do |value, row, col|
      @symbols << [row, col, value] if value.match(/[^(.)\d\s]/)
    end
  end

  # Part 2
  def get_gear_locations(data)
    create_matrix(data)
    calculate_gear_index(data)

    check_positions(data)

    puts "part locations: #{@part_locations}"
    puts "part locations sum: #{part_locations.sum}"
  end

  def calculate_gear_index(data)
    create_matrix(data)
    @matrix.each_with_index do |value, row, col|
      @symbols << [row, col, value] if value.match(/[*]/)
    end
  end

  def check_positions(data)
    @symbols.each_with_index do |s, i|
      sym = gear_line_match(s[0], s[1])

      if sym.first.to_i >= 2
        sym = sym.drop(1).flatten(1)
        sym.each do |s|
          calculate_center(s[0], s[1], @matrix[s[0], s[1]])
        end

        @part_locations << temp_val.inject(:*)
        temp_val.clear
      end
    end

    @numbers = @numbers
  end

  def gear_line_match(row, col)
    part_nums = 0
    temp = []
    left_col = col - 1
    right_col = col + 1

    (row - 1..row + 1).each do |r|
      if @matrix[r, col].match(/[0-9]/)
        temp << [r, col]
        part_nums += 1
      end
      if !@matrix[r, col].match(/[0-9]/) && @matrix[r, right_col].match(/[0-9]/) && @matrix[r, left_col].match(/[0-9]/)
        temp << [r, right_col]
        temp << [r, left_col]
        part_nums += 2
      end
      if !@matrix[r, col].match(/[0-9]/) &&  !@matrix[r, left_col].match(/[0-9]/) && @matrix[r, right_col].match(/[0-9]/)
        temp << [r, right_col]
        part_nums += 1
      end
      if !@matrix[r, col].match(/[0-9]/) && !@matrix[r, right_col].match(/[0-9]/) &&  @matrix[r, left_col].match(/[0-9]/)
        puts "left"
        temp << [r, left_col]
        part_nums += 1
      end
    end

    return [part_nums, temp]
  end

  def calculate_center(row, col, val)
    l = 1
    loop do
      if @matrix[row, col - l].match(/[0-9]/) && col - l >= 0
        val = @matrix[row, col - l].to_s + val.to_s
        l += 1
      else
        break
      end
    end

    r = 1
    loop do
      if @matrix[row, col + r].match(/[0-9]/) && col
        val = val.to_s + @matrix[row, col + r].to_s
        r += 1
      else
        break
      end
    end

    temp_val << val.to_i
  end
end

Puzzle3.new.get_gear_locations(File.readlines('03-input.txt'))
