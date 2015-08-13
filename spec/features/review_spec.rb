require "rails_helper"

describe "Review a card" do
  before(:all) do
    @user = create(:user, password: "abracadabra")
  end
  before(:each) { login(@user, "abracadabra") }

  let!(:deck) { create(:deck, user_id: @user.id) }
  let!(:card) { create(:card, deck_id: deck.id) }

  context "check attributes" do
    before(:each) { visit root_path }

    it "shows a translated text for card" do
      expect(page).to have_content "Достопримечательность"
    end
    it "doesn't show original text" do
      expect(page).to_not have_content "Sehenswürdigkeit"
    end
  end

  context "check review_date" do
    before(:each) do
      @second_card = create(:second_card, deck_id: deck.id)
      card.update_attributes(review_date: Date.today + 1.day)
    end

    it "shows a card with review_date less or equal today" do
      visit root_path
      expect(page).to have_content "Велосипед"
    end
    it "doesn't show the card with review_date greater today" do
      @second_card.update_attributes(review_date: Date.today + 1.day)
      visit root_path
      expect(page).to have_content "Непроверенных карточек нет"
    end
  end

  context "check deck" do
    it "shows a card if current deck is not defined" do
      @user.update_attributes(current_deck: nil)
      visit root_path
      expect(page).to have_content "Достопримечательность"
    end
    it "shows a card from current deck" do
      @user.update_attributes(current_deck: deck)
      visit root_path
      expect(page).to have_content "Достопримечательность"
    end
    it "doesn't show the card from other deck" do
      @user.update_attributes(current_deck: deck)
      card.update_attributes(review_date: Date.today + 1.day)
      second_deck = create(:second_deck, user_id: @user.id)
      create(:second_card, deck_id: second_deck.id)
      visit root_path
      expect(page).to_not have_content "Велосипед"
    end
  end

  context "send an answer" do
    before(:each) { visit root_path }

    it "shows success message if answer is right" do
      fill_in "review_answer", with: "Sehenswürdigkeit"
      click_button "Ответить"
      expect(page).to have_content "Верный ответ!"
    end
    it "shows error message if answer is wrong" do
      fill_in "review_answer", with: "Denkmal"
      click_button "Ответить"
      expect(page).to have_content "Вы ошиблись!"
    end
    it "shows card one more time if answer is wrong" do
      card.update_attributes(attempt: 1)
      fill_in "review_answer", with: "Denkmal"
      click_button "Ответить"
      expect(page).to have_content "Достопримечательность"
    end
    it "shows right answer if answer is wrong" do
      card.update_attributes(attempt: 2)
      fill_in "review_answer", with: "Denkmal"
      click_button "Ответить"
      expect(page).to have_content "Sehenswürdigkeit"
    end
    it "shows success message if answer has misprint" do
      fill_in "review_answer", with: "Sehenswurdigkeit"
      click_button "Ответить"
      expect(page).to have_content "Верный ответ!"
    end
    it "shows misprint message if answer has misprint" do
      fill_in "review_answer", with: "Sehenswurdigkeit"
      click_button "Ответить"
      expect(page).to have_content "опечатка"
    end
    it "doesn't updates review_date if answer missed" do
      click_link "Не знаю"
      expect(page).to have_content "Достопримечательность"
    end
  end

  context "work with own cards" do
    it "doesn't show the card belongs to other user" do
      second_user = create(:user, password: "secret")
      second_deck = create(:deck, user_id: second_user.id)
      create(:second_card, deck_id: second_deck.id)
      visit root_path
      expect(page).to_not have_content "Велосипед"
    end
  end
end
