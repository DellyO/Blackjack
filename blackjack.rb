# Blackjack Simulation Program
# By Nathan Dell, Justin Dell

require './strategy'
require './count_cards'
# Initialize the deck
DECK = [11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10]
# Initialize player and dealer hands
player_hand = []
dealer_hand = []
# Initialize number of decks
number_of_decks = 6
# Initialize the shoe
shoe = DECK * number_of_decks
# Initialize starting budget
budget = 1000000
# Initialize bet, can be changed later
bet = 10
# Initialize deck penetration
penetration_number = shoe.size * 0.25
# Initialize blackjack payouts
blackjack_payout = 1.5
# Initialize number of simulations
simulations = 10000
# Initialize how much to increase bets based on count
# bet_count_multiplier = bet + (bet * bet_count_factor * true_count)
# Initialize running count
running_count = 0
# Initialize true count
true_count = 0

# Run through as many shoes as there are simulations
simulations.times do
	# Refresh/create the shoe
	shoe = DECK * 6
	# Shuffle the new shoe
	shoe.shuffle!
    # Run through the shoe until penetration is met
	while shoe.size > penetration_number
		# Count the hands
		running_count = count_cards(player_hand)
		running_count = count_cards(player_hand)
		# Calculate the true count by dividing running count by decks remaining
		# true_count = running_count / (shoe.size / 52)
		# Increase bet based on true count
		# bet = bet * bet_count_multiplier
		# Clear the hands
		player_hand.clear
		dealer_hand.clear
		# Deal two cards to each
		2.times do
			player_hand << shoe.pop
			dealer_hand << shoe.pop
		end
		# Check for blackjacks
		if dealer_hand[0] + dealer_hand[1] == 21
			if player_hand[0] + player_hand[1] == 21
				# If both have blackjack, then tie
				next
			else
				# If dealer has blackjack, lose bet
				budget = budget - bet
				next
			end
		end
		if player_hand[0] + player_hand[1] == 21
			# If player has blackjack, win bet times blackjack payout
			budget = budget + bet * blackjack_payout
		end
		puts running_count
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