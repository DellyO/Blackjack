require 'forwardable'

#
# Hand
#
# - a players cards along with the bet associated with it
#
class Hand
  extend Forwardable

  attr_accessor :bet
  def_delegators :@cards, :[], :[]=, :<<, :size, :to_s

  def initialize cards, bet = 0
    cards[cards.find_index(1)] = 11 if cards.include?(1)
    @cards = cards
    @bet = bet
  end

  def soft?
    @cards.include? 11
  end

  def pair?
    return true if @cards.size == 2 && @cards.include?(11) && @cards.include?(1)
    @cards.size == 2 && @cards[0] == @cards[1]
  end

  def blackjack?
    size == 2 && value! == 21
  end

  def bust?
    value! > 21 && !soft?
  end

  def value!
    value = @cards.inject(0){|acc,c| acc + c}
    if soft? && value > 21
      @cards[@cards.find_index(11)] = 1
      return value!
    end
    value
  end
end
