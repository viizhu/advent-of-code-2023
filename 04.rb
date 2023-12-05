class Puzzle4
  attr_accessor :input, :card, :points

  def initialize
    @input = File.readlines('04-input.txt')
    @card = []
    @points = []
  end

  def convert_to_array
    @input.each do |line|
      line = line.split(/[:|]/)
      card_name = line[0].match(/\d+/)[0].to_i
      winning_numbers = line[1].split(/ /).reject!(&:empty?).map(&:to_i)
      played_numbers = line[2].split(/ /).reject!(&:empty?).map(&:to_i)

      @card << [card_name, winning_numbers, played_numbers]
    end
  end

  def find_winning_numbers
    convert_to_array
    card.each do |card|
      matched = card[2] & card[1]

      i = 1
      p = 1
      while i < matched.count && matched.count != 0
        p *= 2
        i += 1
      end
      @points << p unless matched.count == 0
    end

    puts "points: #{@points.sum}"
  end
end


Puzzle4.new.find_winning_numbers
