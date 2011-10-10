# Blackjack Simulation Program
# By Nathan Dell, Justin Dell

require './strategy'
require './array'
require 'yaml'

# Initialize the deck
DECK = [2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11]
CONFIG = YAML.load_file("config.yml")

shoe = DECK * CONFIG['decks'] # Initialize the shoe
penetration_number = shoe.size * 0.25 # Initialize deck penetration
@budget = CONFIG['budget'] # Initialize starting @budget
bet = 10 # Initialize bet, can be changed later
true_count = 0 # Initialize true count
@strategy = Strategy.new

def deal_card shoe
  card = shoe.pop
  @strategy.count_card(card)
  card
end

def play_hand player_hand, dealer_hand, bet, shoe
  if player_hand.blackjack_value! == 21
    # If player has blackjack, win bet times blackjack payout
    @budget = @budget + bet * CONFIG['blackjack_payout']
  end
  
  action = @strategy.determine_action(player_hand.blackjack_value!, dealer_hand[1], {'soft' => player_hand.soft?, 'pair' => player_hand.pair?})
  while action != 'STAND' && player_hand.blackjack_value! < 21
    # puts "#{player_hand.inspect}\t#{action}\tDealer: #{dealer_hand[1]}"
    case action
    when 'HIT'
      player_hand << deal_card(shoe)
    when 'DOUBLE'
      unless player_hand.size > 2
        bet *= 2
        action = 'HIT'
      end        
      player_hand << deal_card(shoe)
      break
    when 'SURRENDER'
      bet /= 2
      break
    when 'SPLIT'
      play_hand [player_hand[0], deal_card(shoe)], dealer_hand, bet, shoe
      play_hand [player_hand[1], deal_card(shoe)], dealer_hand, bet, shoe
      # TODO: player can't hit after splitting aces
      return
    when 'STAND'
      next
    else
      break
    end
    action = @strategy.determine_action(player_hand.blackjack_value!, dealer_hand[1], {'soft' => player_hand.soft?, 'pair' => player_hand.pair?})
  end

  while dealer_hand.blackjack_value! < 17
    dealer_hand << deal_card(shoe)
  end
  
  if player_hand.blackjack_value! > 21
    @budget -= bet
  elsif dealer_hand.blackjack_value! > 21
    @budget += bet
  elsif dealer_hand.blackjack_value! > player_hand.blackjack_value!
    @budget -= bet
  elsif player_hand.blackjack_value! > dealer_hand.blackjack_value!
    @budget += bet
  end
  # TODO: if surrender make sure player doesn't get paid on dealer bust
end

# Run through as many shoes as there are simulations
CONFIG['simulations'].times do
	shoe = (DECK * 6).shuffle # Refresh/create the shoe and shuffle
  @strategy.reset_count

  # Run through the shoe until penetration is met
  while shoe.size > penetration_number do
    # Initialize player and dealer hands
    player_hand = []
    dealer_hand = []

    # Calculate the true count by dividing running count by decks remaining
    true_count = @strategy.count / (shoe.size / 52)
    # Increase bet based on true count
    bet = bet * CONFIG['bet_multiplier']
    if bet < CONFIG['minimum_bet']
      bet = CONFIG['minimum_bet']
    end

    # Deal two cards to each
    2.times do
      player_hand << deal_card(shoe)
      dealer_hand << deal_card(shoe)
    end

    # Check for blackjacks
    if dealer_hand.blackjack_value! == 21
      if player_hand.blackjack_value! == 21
        # If both have blackjack, then tie
        next
      else
        # If dealer has blackjack, lose bet
        @budget = @budget - bet
        next
      end
    end
    
    play_hand player_hand, dealer_hand, bet, shoe
  end
end

puts "Ending budget is $#{@budget}"
