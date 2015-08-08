FactoryGirl.define do
  factory :deck do
    name "Колода №1"
    user
  end

  factory :second_deck, parent: :deck do
    name "Колода №2"
  end
end
