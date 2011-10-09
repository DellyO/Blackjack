require './array'
require 'test/unit'

class ArrayTest < Test::Unit::TestCase
  def test_soft
    assert [11,11].soft?
    assert [10,11].soft?
    assert [9,11].soft?
    assert [8,11].soft?
    assert [7,11].soft?
    assert [6,11].soft?
    assert [5,11].soft?
    assert [4,11].soft?
    assert [3,11].soft?
    assert [2,11].soft?
    assert ![2,11,10].soft?
    assert ![2,11,9].soft?
    assert ![2,11,8].soft?
    assert [2,11,7].soft?
    assert [2,11,6].soft?
    assert [2,11,5].soft?
    assert [2,11,4].soft?
    assert [2,11,3].soft?
    assert [2,11,2].soft?
  end

  def test_pair
  end

  def test_blackjack_value
    assert_equal [10,11].blackjack_value, 21
  end
end
