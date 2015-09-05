require "rails_helper"

describe "Card form" do
  before(:each) do
    login(user, "abracadabra")
  end

  let!(:user) { create(:user, password: "abracadabra") }

  it "creates deck from card form" do
    visit new_dashboard_card_path
    fill_in "Исходный текст", with: "Abracadabra"
    fill_in "Перевод текста", with: "Абракадабра"
    fill_in "Создать новую колоду", with: "Новая колода"
    click_button "Создать карточку"
    expect(page).to have_content "Новая колода"
  end
end
