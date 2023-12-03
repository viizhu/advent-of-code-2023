class PuzzleTwo
  data = File.readlines('02-input.txt').map(&:to_s)

  def self.part_1(games)
    hash = max_cubes_by_color(games)
    bag = { 'red' => 12, 'green' => 13, 'blue' => 14 }
    valid_games = []

    hash.each do |game, pulls|
      if pulls['red'].to_i <= bag['red'].to_i && pulls['green'].to_i <= bag['green'].to_i && pulls['blue'].to_i <= bag['blue'].to_i
        valid_games << game.to_i
      else
      end
    end

    puts valid_games.sum
  end

  def self.max_cubes_by_color(games)
    hash = convert_to_hash(games)
    hash.map do |game, pulls|
      hash[game] = pulls.reduce do |memo, pull|
        memo.merge!(pull) do |key, old, new|
          old.to_i > new.to_i ? old.to_i : new.to_i
        end
      end
    end
    return hash
  end

  def self.convert_to_hash(games)
    hash = {}
    games.each do |game|
      game_name = game.match(/(Game \d+: )(.*)/)[1]
      game_name = game_name.match(/\d+/)[0].to_i
      game_pulls = game.match(/(Game \d+: )(.*)/)[2]
      game_pulls = game_pulls.split(/;/).map(&:strip)
      array = []

      game_pulls.each do |pull|
        y = pull.split(/,/).map do |x|
          matches = x.match(/.*?(\d+) (\w+)/)
          { matches[2] => matches[1] }
        end

        array << y.reduce({}, :merge)
      end

      hash[game_name] = array
    end
    return hash
  end

  part_1(data)
end
