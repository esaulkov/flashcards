require "rails_helper"

describe Card do

  context "with valid attributes" do
    let!(:card) { create(:card) }

    it "is valid if original text isn't equal to translated text" do
      expect(card).to be_valid
    end
    it "updates review_date if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.review_date).to eq 3.days.from_now.to_date
    end
    it "returns true if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      expect(card.check_answer(answer)).to eq true
    end
    it "returns true if answer is in other case" do
      answer = "seHenswürDigkeit"
      expect(card.check_answer(answer)).to eq true
    end
    it "returns true if answer ends with blank symbol" do
      answer = "Sehenswürdigkeit "
      expect(card.check_answer(answer)).to eq true
    end
    it "returns true if answer begins with spaces" do
      answer = "  Sehenswürdigkeit"
      expect(card.check_answer(answer)).to eq true
    end
  end

  context "with invalid attributes" do
    it "is invalid if original_text equal translated_text" do
      card = build(:card, translated_text: "Sehenswürdigkeit")
      card.valid?
      bad_translate = "Исходный текст и перевод должны различаться"
      expect(card.errors[:translated_text]).to include(bad_translate)
    end
    it "does not update review_date if answer is not equal to original_text" do
      card = build(:card, review_date: Date.today)
      answer = "Sight"
      card.check_answer(answer)
      expect(card.review_date).to eq Date.today
    end
    it "returns false if answer is not equal to original_text" do
      card = build(:card)
      answer = "Sight"
      expect(card.check_answer(answer)).to eq false
    end
  end

end
