FactoryGirl.define do
  factory :card do
    original_text "Sehenswürdigkeit"
    translated_text "Достопримечательность"
    review_date Date.today.strftime("%d/%m/%Y")
  end
end
