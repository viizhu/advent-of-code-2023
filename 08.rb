class Puzzle8
  attr_accessor :input, :directions, :nodes

  def initialize
    @input = File.readlines('08-input.txt')
    @directions = nil
    @nodes = {}

    format_input
  end

  def format_input
    @directions = @input[0].chars.map(&:chomp).reject(&:empty?)
    @input.shift
    @input.map(&:chomp).reject(&:empty?).each do |line|
      line = line.split.each { |x| x.gsub!(/(=|\(|\)|,)/, '') }.reject(&:empty?)
      @nodes[line[0]] = { "L" => line[1], "R" => line[2]}
    end
  end

  def navigate
    el = "AAA"
    steps = 1
    dir = 0
    loop do
      el = nodes[el][directions[dir]]
      if el == "ZZZ"
        break
      else
        dir < (directions.length - 1) ? dir += 1 : dir = 0
        steps += 1
      end
    end
    puts "steps: #{steps}"
  end
end

Puzzle8.new.navigate
