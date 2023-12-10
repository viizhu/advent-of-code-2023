class Puzzle8
  attr_accessor :input, :directions, :nodes

  def initialize
    @input = File.readlines('08-input.txt')
    @directions = nil
    @nodes = {}

    format_input
    puts "directions: #{directions}"
    puts "nodes: #{nodes}"
  end

  def format_input
    @directions = @input[0].chars.map(&:chomp).reject(&:empty?)
    @input.shift
    @input.map(&:chomp).reject(&:empty?).each do |line|
      line = line.split.each { |x| x.gsub!(/(=|\(|\)|,)/, '') }.reject(&:empty?)
      @nodes[line[0]] = { "L" => line[1], "R" => line[2]}
    end
  end

  def navigate_pt1
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

  def navigate
    els = []
    nodes.select do |k, v|
      k.match(/..(A)/) ? els << k : next
    end

    puts "els: #{els}"
    steps = 1
    dir = 0
    loop do
      results = []
      els.length.times do |i|
        results << nodes[els[i]][directions[dir]]
      end

      counter = 0
      results.each { |r| r.match(/..(Z)/) ? counter += 1 : next }
      break if counter == els.length
      els = results
      dir < (directions.length - 1) ? dir += 1 : dir = 0
      steps += 1

      puts "els: #{els}, count: #{counter}"
    end
    puts "steps: #{steps}"
  end
end

Puzzle8.new.navigate
