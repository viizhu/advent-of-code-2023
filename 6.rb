class Puzzle6
  attr_accessor :input, :time, :record, :wins

  def initialize
    @input = File.readlines('06-input.txt')
    @time = []
    @record = []
    @wins = []

    format_input
  end

  def format_input
    @time = input[0].split(/:/).drop(1).map { |x| x.gsub(/\s+/, "") }.map(&:to_i)
    @record = input[1].split(/:/).drop(1).map { |x| x.gsub(/\s+/, "") }.map(&:to_i)
  end

  def beat_record?(speed, time, distance)
    speed * (time - speed) > distance
  end

  def calculate_distance(speed, time)
    speed * (time - speed)
  end

  def increase_speeds(speed, time, distance)
    winning_speeds = []
    loop do
      if beat_record?(speed, time, distance)
        winning_speeds << speed
        speed += 1
      else
        break
      end
    end
    winning_speeds
  end

  def decrease_speed(speed, time, distance)
    winning_speeds = []
    loop do
      if beat_record?(speed, time, distance)
        winning_speeds << speed
        speed -= 1
      else
        break
      end
    end
    winning_speeds
  end

  def find_lower_start(speed, time, distance)
    loop do
      beat_record?(speed, time, distance) ? speed -= 1 : break
    end
    speed
  end

  def find_upper_start(speed, time, distance)
    loop do
      beat_record?(speed, time, distance) ? speed += 1 : break
    end
    speed
  end

  def set_speed
    (time.count).times do |i|
      speeds = []
      mid = (time[i] / 2).floor
      if beat_record?(mid, time[i], record[i])
        speeds << decrease_speed(mid, time[i], record[i])
        speeds << increase_speeds(mid + 1, time[i], record[i])
      else
        lower_start = find_lower_start(mid, time[i], record[i])
        upper_start = find_upper_start(mid + 1, time[i], record[i])

        speeds << decrease_speed(upper_start, time[i], record[i])
        speeds << increase_speeds(lower_start, time[i], record[i])
      end

      wins << speeds.flatten.count
      i += 1
    end
    puts "final wins: #{wins}"
    puts "final wins product: #{wins.inject(:*)}"
  end
end

Puzzle6.new.set_speed
