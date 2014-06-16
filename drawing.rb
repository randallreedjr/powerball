require_relative "config/environment.rb"

class Drawing

  attr_accessor :date, :numbers, :powerball, :powerplay, :matching_numbers, :powerball_match
  attr_reader :jackpot

  def initialize
    @date = ""
    @numbers = []
    @powerball = 0
    @powerplay = ""
    @powerball_match = false
    @jackpot = 10_000_000
  end

  def check_numbers(ticket)
      if ticket.date != date
        return 0
      end
      @matching_numbers = 0
      ticket.numbers.each do |number|        
        @matching_numbers += 1 if numbers.include?(number)
      end
      @powerball_match = (ticket.powerball == powerball)
      @ticket_powerplay = ticket.powerplay?
  end

  def calc_winnings
    @ticket_powerplay ? multiplier = @powerplay.to_i : multiplier = 1
    case powerball_match
    when true
      case matching_numbers
      when 0,1
        return 4 * multiplier
      when 2
        return 7 * multiplier
      when 3
        return 100 * multiplier
      when 4
        return 10_000 * multiplier
      when 5
        #No way to know the actual jackpot amount
        return @jackpot
      end
    when false
      case matching_numbers
      when 1, 2
        return 0
      when 3
        return 7 * multiplier
      when 4
        return 100 * multiplier
      when 5
        return min(1_000_000 * multiplier, 2_000_000)
      end
    end
    return 0
  end
end