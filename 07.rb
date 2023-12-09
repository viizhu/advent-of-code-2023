class Puzzle7
  attr_accessor :input, :ranks, :winnings

  def initialize
    @input = File.readlines('07-input.txt')
    @ranks = {1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => []}
    @winnings = []

    format_input
  end

  def format_input
    hands = []
    bids = []
    input.each do |set|
      hands << set.split(' ')[0]
      bids << set.split(' ')[1]
    end
    bids.map!(&:to_i)

    hands.each do |h|
      if h.include?('J')
        sorted_j_hand = h.chars.sort(&:casecmp) # sort hand by card
        j_card_dups = count_j_cards(sorted_j_hand) # find card duplicates
        calculate_types(h, j_card_dups, hands, bids)
      else
        sorted_hand = h.chars.sort(&:casecmp) # sort hand by card
        card_dups = count_cards(sorted_hand) # find card duplicates
        calculate_types(h, card_dups, hands, bids)
      end
    end

    @ranks = Hash[ ranks.sort_by { |key, val| key } ]
    puts "ranks[1]: #{ranks[1]}"
    puts "ranks[2]: #{ranks[2]}"
    puts "ranks[3]: #{ranks[3]}"
    puts "ranks[4]: #{ranks[4]}"
    puts "ranks[5]: #{ranks[5]}"
    puts "ranks[6]: #{ranks[6]}"
    puts "ranks[7]: #{ranks[7]}"
  end

  def convert_letter_cards(card)
    case card
    when 'T'
      10
    when 'Q'
      11
    when 'K'
      12
    when 'A'
      13
    when 'J'
      1
    else
      card.to_i
    end
  end

  def calculate_types(h, card_dups, hands, bids)
    idx = hands.index(h)
    if card_dups.empty?
      # High card, where all cards' labels are distinct: 23456
      insert_into_rank(1, h, bids[idx])
    elsif card_dups[0][1] == 5
      # Five of a kind, where all five cards have the same label: AAAAA
      insert_into_rank(7, h, bids[idx])
    elsif card_dups[0][1] == 4
      # Four of a kind, where four cards have the same label and one card has a different label: AA8AA
      insert_into_rank(6, h, bids[idx])
    elsif card_dups.length == 2
      if card_dups[0][1] == 2 && card_dups[1][1] == 2
        # Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
        insert_into_rank(3, h, bids[idx])
      else
        # Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
        insert_into_rank(5, h, bids[idx])
      end
    elsif card_dups[0][1] == 2
      # One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
      insert_into_rank(2, h, bids[idx])
    else
      # Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
      insert_into_rank(4, h, bids[idx])
    end
  end

  def count_cards(hand)
    duplicates = []
    hand.each do |card|
      duplicates << [card, hand.count(card)] if hand.count(card) > 1
    end
    duplicates.uniq
  end

  def count_j_cards(hand)
    duplicates = []
    without_j = hand.reject { |e| e == 'J' }
    without_j.each do |card|
      duplicates << [card, hand.count(card)] if hand.count(card) > 1
    end
    duplicates = duplicates.uniq
    j_nums = 5 - without_j.length
    if duplicates.length > 1
      duplicates[0][1] = 3
    elsif duplicates.empty?
      case j_nums
      when 1
        duplicates << ['J', 2]
      when 5
        duplicates << ['J', 5]
      else
        duplicates << ['J', j_nums + 1]
      end
    else
      case duplicates[0][1]
      when 2
        duplicates[0][1] = 2 + j_nums
      when 3
        duplicates[0][1] = 3 + j_nums
      when 4
        duplicates[0][1] = 4 + j_nums
      end
    end
    duplicates.uniq
  end

  def insert_into_rank(rank, hand, bid)
    ranks[rank] << [hand, bid]
  end

  def calculate_ranks(values)
    split_values = []
    return values if values.length == 1
    values.each do |v|
      split_values << [v[0].chars.map! { |e| convert_letter_cards(e) }, v[0], v[1]]
    end
    split_values.sort! {|a,b| a[0] <=> b[0]}
    split_values.each { |e| e.shift }
  end

  def play
    r = 1
    ranks.each do |k, v|
      sorted_values = calculate_ranks(v)
      sorted_values.each do |sv|
        winnings << sv[1] * r
        r += 1
      end
    end

    puts "winnings: #{winnings.sum}"
  end
end

Puzzle7.new.play
