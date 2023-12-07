class Puzzle5
  attr_accessor :input, :seeds, :part_2_seeds, :almanac, :location

  def initialize
    @input = File.readlines('05-input.txt')
    @seeds = []
    @part_2_seeds = []
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

    @seeds.each_slice(2) { |s| @part_2_seeds << s }
    puts "seeds: #{seeds}"
    puts "almanac: #{almanac}"
    puts "part_2_seeds: #{part_2_seeds}"
  end

  def source_in_destination?(source, map)
    map.each_with_index.map do |m, i|
      # puts "map: #{map}, m: #{m}, i: #{i}"
      # print "\nif #{source[0]} "
      # print "<= #{(m[1] + m[2])} "
      # print "&& #{m[1]} "
      # print "<= #{(source[0] + source[1])}\n"
      if (source[0] <= (m[1] + m[2])) && (m[1] <= (source[0] + source[1]))
        # puts "i: #{i}"
        # puts "map[i]: #{map[i]}"
        return i
      # elsif (source[0] <= (m[1] + m[2])) && !(m[1] <= (source[0] + source[1]))
      #   # puts "hi"
      #   return nil
      # elsif !(source[0] <= (m[1] + m[2])) && (m[1] <= (source[0] + source[1]))
      #   # puts "bye"
      #   return nil
      # else
        # puts "else"
        # return nil
      end
    end
    nil
  end

  def set_destination(source, i, map)
    puts "-----------source: #{source}, i: #{i}, map: #{map}"
    puts "map[i]: #{map[i]}"
    79
    # source - map[i][1] + map[i][0]
  end

  def lowest_location_number
    part_2_seeds.each do |seed_range|
      source = seed_range
      almanac.each do |map|
        if source_in_destination?(source, map)
          source = set_destination(source, source_in_destination?(source, map), map)
        # else
        #   source = source
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
