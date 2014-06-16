require_relative "config/environment.rb"

class PowerballScraper

  attr_reader :url, :drawings

  def initialize()
    @url = "http://www.powerball.com/powerball/pb_numbers.asp"
    @drawings = []
  end

  def scrape()
    html = open(url).read
    doc = Nokogiri::HTML(html)
    array = doc.search("b")
    array.each do |possible_match|
      text = possible_match.text.gsub(/\s+/,"")
      if not text.match(/[\d]+/)
        next
      elsif text.match(/\d{1,2}\/\d{1,2}\/\d{4}/)
        drawings << Drawing.new
        drawings.last.date = text
      else
        if text.match(/\dX/)
          drawings.last.powerplay = text
        elsif drawings.last.numbers.size == 5
          drawings.last.powerball = text
        else
          drawings.last.numbers << text
        end
      end
    end
  end
end