require "open-uri"

Card.delete_all

urls = [*1..4].map { |a| "http://w2mem.com/words/de/#{a}/" }
urls.each do |pageUrl|
  doc = Nokogiri::HTML(open(pageUrl))
  src = doc.css('input[@name="dst"]')
  dst = doc.css('input[@name="src"]')

  src.each do |source|
    Card.create([
      {
        original_text: source["value"],
        translated_text: dst[src.index(source)]["value"],
        review_date: Date.today
      }
    ])
  end
end
