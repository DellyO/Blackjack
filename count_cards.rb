# Count Cards function
module Count_cards
count = 0
	def self.action hand
		card_value = 0
		
		hand.each do |i|
			if hand[i] == 1 || hand[i] == 11 || hand[i] == 10
				card_value = -1
			end
			if hand[i] == 2 || hand[i] == 3 || hand[i] == 4 || hand[i] == 5 || hand[i] == 6
				card_value = 1
			end
			if hand[i] == 7 || hand[i] == 8 || hand[i] == 9
				card_value = 0
			end
			count = count + card_value
		end
	end
	puts count
	return count
end
		