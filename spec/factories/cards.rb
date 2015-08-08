FactoryGirl.define do
  factory :card do
    original_text "Sehenswürdigkeit"
    translated_text "Достопримечательность"
    review_date Date.today.strftime("%d/%m/%Y")
    deck

    after(:create) do |card|
      card.update_attributes(review_date: Date.today)
    end
  end

  factory :second_card, parent: :card do
    original_text "Fahrrad"
    translated_text "Велосипед"
  end
end
