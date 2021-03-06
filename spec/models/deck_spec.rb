require "rails_helper"

describe Deck do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }

  it "current? returns true if user's current deck set on this deck" do
    user.update_attributes(current_deck: deck)
    expect(deck.current?).to eq true
  end
end
