require "rails_helper"

describe "Change current deck" do
  before(:all) do
    @user = create(:user, password: "abracadabra")
  end

  before(:each) do
    login(@user, "abracadabra")
  end

  let!(:deck) { create(:deck, user_id: @user.id) }
  let!(:second_deck) { create(:second_deck, user_id: @user.id) }

  it "doesn't have current deck" do
    visit decks_path
    expect(page).to_not have_content "Текущая"
  end

  it "changes current flag" do
    visit decks_path
    click_link("Сделать текущей", match: :first)
    visit decks_path
    expect(page).to have_content "Текущая"
  end

  it "has only one current deck" do
    @user.update_attributes(current_deck: deck)
    visit decks_path
    click_link("Сделать текущей")
    visit decks_path
    expect(page).to have_content("Текущая", count: 1)
  end

  it "works with own decks" do
    second_user = create(:user, password: "secret")
    second_deck.update_attributes(user_id: second_user.id)
    visit decks_path
    expect(page).to_not have_content "Вторая колода"
  end
end
