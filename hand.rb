require 'forwardable'

#
# Hand
#
# - a players cards along with the bet associated with it
#
class Hand
  extend Forwardable

  attr_accessor :bet
  def_delegators :@cards, :[], :[]=, :<<, :inject, :size, :include?, :find_index, :to_s

  def initialize cards, bet = 0
    @cards = cards
    @bet = bet
  end

  def soft?
    include? 11
  end

  def pair?
    size == 2 && self[0] == self[1]
  end

  def blackjack?
    size == 2 && value! == 21
  end

  def bust?
    value! > 21 && !soft?
  end

  def value!
    value = inject(0){|acc,c| acc + c}
    if soft? && value > 21
      self[find_index(11)] = 1
      return value!
    end
    value
  end
end
