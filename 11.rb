class Puzzle11
  def initialize
    @input = File.readlines("11-input.txt")
    universe = {}
    @input.each.with_index do |line, r|
      line.chomp.chars.each.with_index do |char, c|
        universe[[r, c]] = char
      end
    end

    puts "universe: #{universe}"
  end
end

Puzzle11.new