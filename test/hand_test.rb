require './hand'
require 'test/unit'

class HandTest < Test::Unit::TestCase
  def test_pair
    assert Hand.new([3,3]).pair?
    assert !Hand.new([3,5]).pair?
  end

  def test_value
    assert_value Hand.new([5,6]), 11
    assert_value Hand.new([9,6]), 15
    assert_value Hand.new([10,10]), 20
    assert_value Hand.new([10,11]), 21
    assert_value Hand.new([11,5,9]), 15
    assert_value Hand.new([11,11,4]), 16
    assert_value Hand.new([11,11]), 12
    assert_value Hand.new([10,10,2]), 22
    assert_value Hand.new([10,11,2]), 13
    assert_value Hand.new([10,10,11,2]), 23
  end

  private
  def assert_value arr, expected
    assert_equal expected, arr.value!
  end
end
