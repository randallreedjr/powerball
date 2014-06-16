class Ticket
  attr_accessor :date, :numbers, :powerball, :powerplay

  def initialize
    @date = ""
    @numbers = []
    @powerball = 0
    @powerplay = false
  end

  def powerplay?
    @powerplay
  end
end