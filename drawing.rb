require_relative 'ticket.rb'
require 'pry'

class Drawing

  attr_accessor :date, :numbers, :powerball, :powerplay, :matching_numbers, :powerball_match

  def initialize
    @date = ""
    @numbers = []
    @powerball = 0
    @powerplay = ""
    @powerball_match = false
  end

  def check_numbers(ticket)
      if ticket.date != date
        return 0
      end
      @matching_numbers = 0
      ticket.numbers.each do |number|
        if numbers.include?(number)
          @matching_numbers += 1
        end
      end
      if ticket.powerball == powerball
        @powerball_match = true
      end

  end

  def calc_winnings
    #binding.pry
    case powerball_match
    when true
      case matching_numbers
      when 0,1
        return 4
      when 2
        return 7
      when 3
        return 100
      when 4
        return 10_000
      when 5
        #No way to know the actual jackpot amount
        return 10_000_000
      end
    when false
      case matching_numbers
      when 1, 2
        return 0
      when 3
        return 7
      when 4
        return 100
      when 5
        return 1_000_000
      end
    end
    return 0
  end
end