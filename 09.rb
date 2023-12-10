class Puzzle9
  attr_accessor :input, :history, :predictions, :values

  def initialize
    @input = File.readlines('09-input.txt')
    @history = []
    @predictions = {}
    @values = []

    input.map(&:chomp).map do |line|
      line = line.split(' ').map(&:to_i)
      history << line
    end

    format_input
    puts "history: #{@history}"
    puts "predictions: #{@predictions}"
  end

  def format_input
    history.each_with_index do |line, i|
      predictions[i] = calculate_differences(line)
    end
  end

  def calculate_differences(line)
    diff = [line]
    d = []
    loop do
      (0..diff.first.length - 2).each do |i|
        d << diff.first[i+1] - diff.first[i]
      end
      diff.unshift(d)
      d = []
      break if diff.first.uniq == [0]
    end
    diff
  end

  def next_value
    x = nil
    predictions.each do |k, v|
      predictions[k].each_with_index do |line, i|
        unless v[i+1].nil?
          x = v[i+1].first - line.first
          v[i+1].unshift(x)
        end

      end
      values << x
    end

    puts "values: #{@values}"
    puts "values.sum: #{@values.sum}"
  end
end

Puzzle9.new.next_value