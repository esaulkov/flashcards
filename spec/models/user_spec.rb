require "rails_helper"

describe User do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }
  let!(:card) { create(:card, deck_id: deck.id) }

  it "sends an email if pending card is present" do
    expect {
      User.notify_about_pending_cards
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "doesn't send an email if pending cards are upsent" do
    card.update_attributes(review_date: 1.day.from_now)
    expect {
      User.notify_about_pending_cards
    }.to change { ActionMailer::Base.deliveries.count }.by(0)
  end
end
