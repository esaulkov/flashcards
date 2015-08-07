require "rails_helper"

describe Deck do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }

  it "set current flag to false for all user decks" do
    second_deck = create(:second_deck, user_id: user.id)
    deck.clear_current(user)
    expect(user.decks.where(current: true).count).to eq(0)
  end
end
