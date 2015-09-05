require "rails_helper"

describe "Change current deck" do
  before(:each) do
    login(user, "abracadabra")
  end

  let!(:deck) { create(:deck, user_id: user.id) }
  let!(:second_deck) { create(:second_deck, user_id: user.id) }
  let!(:user) { create(:user, password: "abracadabra") }

  it "doesn't have current deck" do
    visit dashboard_decks_path
    expect(page).to_not have_content "Текущая"
  end

  it "changes current flag" do
    visit dashboard_decks_path
    click_link("Сделать текущей", match: :first)
    visit dashboard_decks_path
    expect(page).to have_content "Текущая"
  end

  it "has only one current deck" do
    user.update_attributes(current_deck: deck)
    visit dashboard_decks_path
    click_link("Сделать текущей")
    visit dashboard_decks_path
    expect(page).to have_content("Текущая", count: 1)
  end

  it "works with own decks" do
    second_user = create(:user, password: "secret")
    second_deck.update_attributes(user_id: second_user.id)
    visit dashboard_decks_path
    expect(page).to_not have_content "Вторая колода"
  end
end
