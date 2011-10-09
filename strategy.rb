# Strategy function to determine hit/stand/split/double/surrender
module Strategy
  def self.action hand, dealer, opts = {}
    return 'HIT' if hand <= 8 && !opts['pair']
    return 'STAND' if hand >= 19
    case hand
    when 4
      return 'HIT' if dealer.between?(8, 11)
      return 'SPLIT'
    when 6
      return 'HIT' if dealer.between?(8, 11)
      return 'SPLIT'
    when 8
      return 'HIT' if dealer.between?(2, 4) || dealer.between?(7, 11)
      return 'SPLIT'
    when 9
      return 'DOUBLE' if dealer.between?(3, 6)
      return 'HIT'
    when 10
      return 'DOUBLE' if dealer <= 9
      return 'HIT'
    when 11
      return 'DOUBLE' if dealer <= 10
      return 'HIT'
    when 12
      return 'SPLIT' if opts['pair'] && opts['soft']
      return 'SPLIT' if dealer.between?(2, 6) && opts['pair']
      return 'STAND' if dealer.between?(4, 6)
      return 'HIT'
    when 13
      return 'DOUBLE' if dealer.between?(5, 6) && opts['soft']
      return 'STAND' if dealer <= 6 && !opts['soft']
      return 'HIT'
    when 14
      return 'SPLIT' if dealer.between?(2, 7) && opts['pair']
      return 'DOUBLE' if dealer.between?(5, 6) && opts['soft']
      return 'STAND' if dealer <= 6 && !opts['soft']
      return 'HIT'
    when 15
      return 'DOUBLE' if dealer.between?(4, 6) && opts['soft']
      return 'STAND' if dealer <= 6 && !opts['soft']
      return 'SURRENDER' if dealer == 10 && !opts['soft']
      return 'HIT'
    when 16
      return 'SPLIT' if opts['pair']
      return 'DOUBLE' if dealer.between?(4, 6) && opts['soft']
      return 'STAND' if dealer <= 6 && !opts['soft']
      return 'SURRENDER' if dealer.between?(9, 11) && !opts['soft']
      return 'HIT'
    when 17
      return 'DOUBLE' if dealer.between?(3, 6) && opts['soft']
      return 'HIT' if opts['soft']
      return 'STAND'
    when 18
      return 'SPLIT' if (dealer.between?(2,6) || dealer.between?(8,9)) && opts['pair']
      return 'DOUBLE' if dealer.between?(3, 6) && opts['soft']
      return 'HIT' if dealer.between?(9, 11) && opts['soft']
      return 'STAND'
    end
  end
end
