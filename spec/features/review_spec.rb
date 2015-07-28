require "rails_helper"

describe "Review a card" do
  let!(:card) { create(:card) }

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
      @second_card = create(:second_card)
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
    it "shows right answer if answer is wrong" do
      fill_in "review_answer", with: "Denkmal"
      click_button "Ответить"
      expect(page).to have_content "Sehenswürdigkeit"
    end
    it "doesn't updates review_date if card missed" do
      click_link "Не знаю"
      expect(page).to have_content "Достопримечательность"
    end
  end
end
