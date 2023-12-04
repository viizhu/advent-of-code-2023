require 'matrix'

class Puzzle3
  attr_reader :numbers, :symbols

  def initialize
    @numbers = []
    @symbols = []
    @matrix = nil
  end

  def check_positions(data)
    calculate_index(data)
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

  def calculate_index(data)
    create_matrix(data)
    @matrix.each_with_index do |value, row, col|
      if value.match(/[^(.)\d\s]/)
        @symbols << [row, col, value]
      end
    end
  end

  def create_matrix(data)
    arr = []
    data.each_index do |index|
      arr[index] = data[index].split('')
    end
    @matrix = Matrix.build(arr.length, arr[0].length) { |row, col| arr[row][col] }
    @matrix.map!(&:chomp)
  end

end

Puzzle3.new.check_positions(File.readlines('03-input.txt'))
