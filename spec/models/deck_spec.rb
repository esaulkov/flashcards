require "rails_helper"

describe Deck do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }

  it "is_current? returns true if user's current deck set on this deck" do
    user.update_attributes(current_deck: deck)
    expect(deck.is_current?).to eq true
  end
end
