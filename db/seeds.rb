require "open-uri"

Card.delete_all
Deck.delete_all
User.delete_all

user = User.create(
  email: "test@example.com",
  password: "123456",
  password_confirmation: "123456"
)

urls = [*1..4].map { |a| "http://w2mem.com/words/de/#{a}/" }
urls.each do |pageUrl|
  doc = Nokogiri::HTML(open(pageUrl))
  src = doc.css('input[@name="dst"]')
  dst = doc.css('input[@name="src"]')

  deck = user.decks.create(name: "Колода №#{Deck.count + 1}")
  src.each do |source|
    deck.cards.create(
      original_text: source["value"],
      translated_text: dst[src.index(source)]["value"],
      review_date: Date.today
    )
  end
end

Card.all.each do |card|
  card.update(review_date: Date.today)
end
