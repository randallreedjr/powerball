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
    before(:all) do
      @drawing = Drawing.new
      @ticket = Ticket.new
      @drawing.date, @ticket.date = "6/14/2014", "6/14/2014"
      @drawing.numbers = "1 2 3 4 5".split(" ")
      @drawing.powerball = "6"
      @drawing.powerplay = "2x"
    end

    it "should return zero if no numbers match" do
      @ticket.numbers = "7 8 9 10 11".split(" ")
      @ticket.powerball = "12"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should not match a regular number to the powerball" do
      @ticket.numbers = "6 7 8 9 10".split(" ")
      @ticket.powerball = "11"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should return zero if one regular number matches" do
      @ticket.numbers = "5 7 8 9 10".split(" ")
      @ticket.powerball = "12"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should return zero if two regular numbers match" do
      @ticket.numbers = "4 5 7 8 9".split(" ")
      @ticket.powerball = "12"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should return seven if three regular numbers match" do
      @ticket.numbers = "3 4 5 7 8".split(" ")
      @ticket.powerball = "12"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(7)
    end

    it "should return one hundred if four regular numbers match" do
      @ticket.numbers = "2 3 4 5 7".split(" ")
      @ticket.powerball = "12"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(100)
    end

    it "should return one million if all five regular numbers match" do
      @ticket.numbers = "1 2 3 4 5".split(" ")
      @ticket.powerball = "12"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(1_000_000)
    end

    it "should return four if only powerball matches" do
      @ticket.numbers = "7 8 9 10 11".split(" ")
      @ticket.powerball = "6"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(4)
    end

    it "should return four if powerball and one other number matches" do
      @ticket.numbers = "1 7 8 9 10".split(" ")
      @ticket.powerball = "6"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(4)
    end

    it "should return seven if powerball and two other numbers match" do
      @ticket.numbers = "1 2 7 8 9".split(" ")
      @ticket.powerball = "6"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(7)
    end

    it "should return one hundred if powerball and three other numbers match" do
      @ticket.numbers = "1 2 3 7 8".split(" ")
      @ticket.powerball = "6"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(100)
    end

    it "should return ten thousand if powerball and four other numbers match" do
      @ticket.numbers = "1 2 3 4 7".split(" ")
      @ticket.powerball = "6"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(10_000)
    end

    it "should return jackpot if powerball and five other numbers match" do
      @ticket.numbers = "1 2 3 4 5".split(" ")
      @ticket.powerball = "6"
      @ticket.powerplay = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(@drawing.jackpot)
    end

    context "powerplay" do
      before(:all) do
        @ticket.powerplay = true
      end
      it "should multiply winnings by powerplay without powerball" do
        @ticket.numbers = "1 2 3 7 8".split(" ")
        @ticket.powerball = "12"
        @drawing.powerplay = "3X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(21)
      end

      it "should multiply winnings by powerplay with powerball" do
        @ticket.numbers = "1 2 3 7 8".split(" ")
        @ticket.powerball = "6"
        @drawing.powerplay = "5X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(500)
      end

      it "should not affect jackpot" do
        @ticket.numbers = "1 2 3 4 5".split(" ")
        @ticket.powerball = "6"
        @drawing.powerplay = "2X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(@drawing.jackpot)
      end

      it "should max out at two million" do
        @ticket.numbers = "1 2 3 4 5".split(" ")
        @ticket.powerball = "12"
        @drawing.powerplay = "4X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(2_000_000)
      end
    end
  end
end