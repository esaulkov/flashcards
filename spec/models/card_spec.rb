require "rails_helper"

describe Card do
  context "with valid attributes" do
    let!(:card) { create(:card) }

    it "is valid if original text isn't equal to translated text" do
      expect(card).to be_valid
    end
  end

  context "with invalid attributes" do
    it "is invalid if original_text equal translated_text" do
      card = build(:card, translated_text: "Sehenswürdigkeit")
      card.valid?
      bad_translate = "Исходный текст и перевод должны различаться"
      expect(card.errors[:translated_text]).to include(bad_translate)
    end
  end
end
