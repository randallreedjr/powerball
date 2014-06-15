require_relative 'powerball_scraper.rb'
require_relative 'drawing.rb'
require_relative 'ticket.rb'

def run
  scraper = PowerballScraper.new
  scraper.scrape()
  ticket = Ticket.new
  puts "What date was your drawing?"
  #To Do - Normalize Date
  ticket.date = gets.chomp
  puts "Enter your five regular numbers"
  ticket.numbers = gets.chomp.split(" ")
  puts "Enter your powerball number"
  ticket.powerball = gets.chomp
  puts "Did you select powerplay? (y/n)"
  ticket.powerplay = (gets.chomp.downcase == "y")

  scraper.drawings.each do |drawing|
    if drawing.date == ticket.date
      drawing.check_numbers(ticket)
      winnings = drawing.calc_winnings
      if winnings > 0
        puts "Congrats! #{winnings}"
      else
        puts "Sorry, 0"
      end
    end
  end
end

run()