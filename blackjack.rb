# Blackjack Simulation Program
# By Nathan Dell, Justin Dell

require './strategy'
require './array'

# Initialize the deck
DECK = [2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11]

number_of_decks = 6 # Initialize number of decks
shoe = DECK * number_of_decks # Initialize the shoe
budget = 1000000 # Initialize starting budget
bet = 10 # Initialize bet, can be changed later
penetration_number = shoe.size * 0.25 # Initialize deck penetration
blackjack_payout = 1.5 # Initialize blackjack payouts
simulations = 1000 # Initialize number of simulations
true_count = 0 # Initialize true count
@strategy = Strategy.new

# Initialize how much to increase bets based on count
# bet_count_multiplier = bet + (bet * bet_count_factor * true_count)

def deal_card shoe
  card = shoe.pop
  @strategy.count_card(card)
  card
end

# Run through as many shoes as there are simulations
simulations.times do
	shoe = (DECK * 6).shuffle # Refresh/create the shoe and shuffle
  @strategy.reset_count

  # Run through the shoe until penetration is met
  while shoe.size > penetration_number do
    # Initialize player and dealer hands
    player_hand = []
    dealer_hand = []

    # Calculate the true count by dividing running count by decks remaining
    # true_count = running_count / (shoe.size / 52)
    # Increase bet based on true count
    # bet = bet * bet_count_multiplier

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
        budget = budget - bet
        next
      end
    end
    if player_hand.blackjack_value! == 21
      # If player has blackjack, win bet times blackjack payout
      budget = budget + bet * blackjack_payout
    end

    puts @strategy.count
	end
end

puts 
puts "Ending budget is $#{budget}"

# Sum the values in the shoe
# Can also be written DECK.inject(0) {|acc, n| acc + n}
    #sum = 0
    #shoe.each do |i|
    #  sum += i
    #end
