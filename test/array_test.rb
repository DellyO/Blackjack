require './array'
require 'test/unit'

class ArrayTest < Test::Unit::TestCase
  def test_pair
    assert [3,3].pair?
    assert ![3,5].pair?
  end

  def test_blackjack_value
    assert_blackjack_value [5,6], 11
    assert_blackjack_value [9,6], 15
    assert_blackjack_value [10,10], 20
    assert_blackjack_value [10,11], 21
    assert_blackjack_value [11,5,9], 15
    assert_blackjack_value [11,11,4], 16
    assert_blackjack_value [11,11], 12
    assert_blackjack_value [10,10,2], 22
    assert_blackjack_value [10,11,2], 13
    assert_blackjack_value [10,10,11,2], 23
  end

  def assert_blackjack_value arr, expected
    assert_equal expected, arr.blackjack_value!
  end
end
