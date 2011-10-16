require './strategy'
require './hand'

#
# Game
#
# - executes a round of blackjack with a given strategy
#
class Game
  def initialize strategy = Strategy.new
    @strategy     = strategy
    @player_hands = []
  end

  def play_hand shoe, bet
    @player_hands.clear
    @player_hands[0], dealer = deal_cards shoe, bet

    # Check for blackjacks
    return 0 if dealer.blackjack? && @player_hands[0].blackjack?
    return -@player_hands[0].bet if dealer.blackjack?
    return (@player_hands[0].bet * CONFIG['blackjack_payout']) if @player_hands[0].blackjack?

    alive = execute(@player_hands[0], dealer, shoe)

    profit = 0
    @player_hands.each do |player|
      profit += calculate_results player, dealer, shoe, alive
    end
    profit
  end

  private
  def deal_card shoe
    card = shoe.pop
    @strategy.count_card(card)
    card
  end

  def deal_cards shoe, bet
    player = Hand.new [], bet
    dealer = Hand.new [], bet
    2.times do
      player << deal_card(shoe)
      dealer << deal_card(shoe)
    end
    return player, dealer
  end

  def calculate_results player, dealer, shoe, alive = true
    return -player.bet unless alive

    while dealer.value! < 17
      dealer << deal_card(shoe)
    end

    if player.bust?
      return -player.bet
    elsif dealer.bust?
      return player.bet
    elsif dealer.value! > player.value!
      return -player.bet
    elsif player.value! > dealer.value!
      return player.bet
    end
    return 0
  end

  def execute player, dealer, shoe
    while !player.bust?
      action = @strategy.determine_action(player.value!, dealer[1], {'soft' => player.soft?, 'pair' => player.pair?})
      # puts "#{action}\tP:#{@player_hands.inspect}\tD:#{dealer}\tBet:#{@player_hands.collect(&:bet)}\tBudget:#{@budget}"
#!! Line not working:  puts "#{budget}, #{@count}, #{@player_hands.collect(&:bet)}" 
      case action
      when 'HIT'
        player << deal_card(shoe)
      when 'DOUBLE'
        unless player.size > 2
          player.bet *= 2
          action = 'HIT'
        end
        player << deal_card(shoe)
        return true
      when 'SURRENDER'
        player.bet /= 2
        return false
      when 'SPLIT'
        @player_hands.delete player
        @player_hands << Hand.new([player[0], deal_card(shoe)], player.bet)
        @player_hands << Hand.new([player[1], deal_card(shoe)], player.bet)
        if player.soft?
          # Skip to calculation if aces were split
          calculate_results @player_hands[-1], dealer, shoe
          calculate_results @player_hands[-2], dealer, shoe
        else
          execute @player_hands[-1], dealer, shoe
          execute @player_hands[-2], dealer, shoe
        end
        return true
      when 'STAND'
        return true
      end
    end

    return false
  end
end

