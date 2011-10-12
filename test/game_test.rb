require './game'
require 'test/unit'
require 'mocha'

class GameTest < Test::Unit::TestCase
  ::CONFIG = {}
  ::CONFIG['blackjack_payout'] = 1.5

  def setup
    Strategy.any_instance.stubs(:count_card)
  end

  def test_blackjacks
    assert_equal 0, Game.new.play_hand(construct_shoe([10,11],[10,11]), 10)
    assert_equal 15, Game.new.play_hand(construct_shoe([10,11],[10,10]), 10)
    assert_equal -10, Game.new.play_hand(construct_shoe([10,10],[10,11]), 10)
  end

  def test_simple
    assert_equal 10, Game.new.play_hand(construct_shoe([10,10],[10,8]), 10)
    assert_equal -10, Game.new.play_hand(construct_shoe([10,8],[10,10]), 10)
    assert_equal 10, Game.new.play_hand(construct_shoe([5,7,6],[10,7]), 10)
    assert_equal -10, Game.new.play_hand(construct_shoe([5,3,9],[9,10]), 10)
    assert_equal 0, Game.new.play_hand(construct_shoe([5,9,5],[9,10]), 10)
  end

  def test_busts
    assert_equal 10, Game.new.play_hand(construct_shoe([10,10],[10,6,6]), 10)
    assert_equal -10, Game.new.play_hand(construct_shoe([10,4,8],[10,10]), 10)
  end

  def test_double
    assert_equal 20, Game.new.play_hand(construct_shoe([5,6,10],[6,6,6]), 10)
    assert_equal -20, Game.new.play_hand(construct_shoe([5,6,2],[6,6,6]), 10)
  end

  def test_surrender
    assert_equal -5, Game.new.play_hand(construct_shoe([6,10],[10,10]), 10)
    assert_equal -5, Game.new.play_hand(construct_shoe([6,10],[6,10,6]), 10)
  end

  def test_split
    assert_equal 20, Game.new.play_hand(construct_shoe([8,8,10,10],[6,6,5]), 10)
    assert_equal -20, Game.new.play_hand(construct_shoe([8,8,10,10],[6,6,7]), 10)
    assert_equal 0, Game.new.play_hand(construct_shoe([8,8,10,7],[6,6,5]), 10)
    assert_equal 30, Game.new.play_hand([10,7,7,7,8,6,8,6,8], 10)
    assert_equal 0, Game.new.play_hand(construct_shoe([11,11,10,2],[6,6,5]), 10)
  end

  private
  def construct_shoe player, dealer
    shoe = []
    while dealer.size > 2
      shoe << dealer.pop
    end
    while player.size > 2
      shoe << player.pop
    end
    shoe << dealer.pop
    shoe << player.pop
    shoe << dealer.pop
    shoe << player.pop
    shoe
  end
end
