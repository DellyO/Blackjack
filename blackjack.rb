# Blackjack Simulation Program
# By Nathan Dell, Justin Dell

require './strategy'
require './game'
require 'yaml'

start = Time.now
# Initialize the deck
DECK = [2,3,4,5,6,7,8,9,10,10,10,10,11,
        2,3,4,5,6,7,8,9,10,10,10,10,11,
        2,3,4,5,6,7,8,9,10,10,10,10,11,
        2,3,4,5,6,7,8,9,10,10,10,10,11]

CONFIG = YAML.load_file("config.yml")

shoe = DECK * CONFIG['decks'] # Initialize the shoe
penetration_number = shoe.size * 0.25 # Initialize deck penetration
budget = CONFIG['budget'] # Initialize starting budget
starting_budget = CONFIG['budget']
strategy = Strategy.new
lines = []
resultsFile = File.open("output.txt", "w+")
resultsFile << "true_count, budget, bet \n"
# Run through as many shoes as there are simulations
CONFIG['simulations'].times do
	shoe = (DECK * 6).shuffle # Refresh/create the shoe and shuffle
  strategy.reset_count

  # Run through the shoe until penetration is met
  while shoe.size > penetration_number do
    # Calculate the true count by dividing running count by decks remaining
    true_count = strategy.count / (shoe.size / 52)
    # Increase bet based on true count
    bet = CONFIG['minimum_bet'] * CONFIG['bet_multiplier'] * true_count
    if bet < CONFIG['minimum_bet']
      bet = CONFIG['minimum_bet']
    end
    if bet > CONFIG['maximum_bet']
      bet = CONFIG['maximum_bet']
    end
    resultsFile << "#{true_count}, #{budget}, #{bet} \n"
    budget += Game.new(strategy).play_hand(shoe, bet)
  end
end
puts "Simulations: #{CONFIG['simulations']}"
puts "Ending budget is $#{budget}"
money_per_hand = ((budget - starting_budget) / CONFIG['simulations']) / 42.9 # 75% penetration, 1 player averages 42.9 hands per shoe
puts "Money per hand: #{money_per_hand}"
finish = Time.now - start
puts "Total run time: #{finish}"
