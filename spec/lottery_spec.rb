require_relative 'spec_helper.rb'

describe PowerballScraper do 
  it "should retrieve the most recent drawing results" do
    scraper = PowerballScraper.new()
    scraper.scrape
    wednesday = Chronic.parse("last wednesday")
    saturday = Chronic.parse("last saturday")

    wednesday > saturday ? date = "#{wednesday.mon}/#{wednesday.day}/#{wednesday.year}" : 
                           date = "#{saturday.mon}/#{saturday.day}/#{saturday.year}"
    expect(scraper.drawings.first.date).to eq(date)
  end

  context "calculating winnings" do
    it "should return zero if no numbers match" do
      drawing = Drawing.new
      ticket = Ticket.new
      drawing.date, ticket.date = "6/14/2014", "6/14/2014"
      drawing.numbers = "1 2 3 4 5".split(" ")
      drawing.powerball = "6"
      drawing.powerplay = "2x"
      ticket.numbers = "7 8 9 10 11".split(" ")
      ticket.powerball = "12"
      ticket.powerplay = false
      drawing.check_numbers(ticket)
      expect(drawing.calc_winnings()).to eq(0)
    end

    #it "should not match a regular number to the powerball" do
    #end
  end
end