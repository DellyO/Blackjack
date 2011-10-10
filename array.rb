class Array
  def soft?
    include? 11
  end

  def pair?
    size == 2 && self[0] == self[1]
  end

  def blackjack_value!
    value = inject(0){|acc,c| acc + c}
    if soft? && value > 21
      self[find_index(11)] = 1
      return blackjack_value!
    end
    value
  end
end
