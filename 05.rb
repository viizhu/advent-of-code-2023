class Puzzle5
  attr_accessor :input, :seeds, :almanac, :location

  def initialize
    @input = File.readlines('05-input.txt')
    @seeds = []
    @almanac = []
    @location = []

    format_input
  end

  def format_input
    idx = -1
    input.each do |line|
      if line.include?('seeds:')
        @seeds = line.split('seeds: ')[1].split.map(&:to_i)
      elsif line.match?(/(map)/)
        @almanac << []
        idx += 1
      elsif line.match?(/\d+/)
        values = line.split.map(&:to_i)
        @almanac[idx] << values
      else
        next
      end
    end

    puts "seeds: #{seeds}"
    puts "almanac: #{almanac}"
  end

  def source_in_destination?(source, map)
    map.each_with_index.map do |m, i|
      return i if (source >= m[1] && source <= (m[1] + m[2]))
    end
    nil
  end

  def set_destination(source, i, map)
    source - map[i][1] + map[i][0]
  end

  def lowest_location_number
    seeds.each do |seed|
      source = seed
      almanac.each do |map|
        if source_in_destination?(source, map)
          source = set_destination(source, source_in_destination?(source, map), map)
        else
          source = source
        end
      end
      location << source
    end
    #
    puts "locations: #{location}"
    puts "location.min: #{location.min}"
  end
end

Puzzle5.new.lowest_location_number
