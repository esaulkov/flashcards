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

  context "check_answer method" do
    let!(:card) { create(:card) }

    def check_time_period(basket)
      card.update_attributes(basket: basket)
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
    end

    it "updates review_date if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.review_date).to be > DateTime.now
    end

    it "updates review_date by different time" do
      Card::OPTIONS.keys.each do |basket|
        check_time_period(basket)
        basket = basket + 1 if basket < 5
        time_period = Card::OPTIONS[basket].days.from_now
        expect(card.review_date).to be_within(1.second).of time_period
      end
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

    it "does not update review_date if answer is not equal to original_text" do
      review_date = DateTime.now
      card = build(:card, review_date: review_date)
      answer = "Sight"
      card.check_answer(answer)
      expect(card.review_date).to eq review_date
    end

    it "returns false if answer is not equal to original_text" do
      card = build(:card)
      answer = "Sight"
      expect(card.check_answer(answer)).to eq false
    end

    it "increases basket field" do
      old_basket = card.basket
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.basket).to eq (old_basket + 1)
    end

    it "doesn't increase basket field if it is max" do
      card.update_attributes(basket: Card::OPTIONS.keys.last)
      old_basket = card.basket
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.basket).to eq old_basket
    end
  end

  context "has_valid_attempt method" do
    let!(:card) { create(:card) }

    it "returns true if attempt is less than two" do
      expect(card.has_valid_attempt).to eq true
    end

    it "returns false if attempt is equal two" do
      card.update_attributes(attempt: 2)
      expect(card.has_valid_attempt).to eq false
    end

    it "increases attempt field if it is less than two" do
      attempt_backup = card.attempt
      card.has_valid_attempt
      expect(card.attempt).to eq (attempt_backup + 1)
    end

    it "clears attempt field if it is equal two" do
      card.update_attributes(attempt: 2)
      card.has_valid_attempt
      expect(card.attempt).to eq 0
    end

    it "decreases basket field if attempt field is equal two" do
      card.update_attributes(attempt: 2, basket: 3)
      old_basket = card.basket
      card.has_valid_attempt
      expect(card.basket).to eq (old_basket - 2)
    end

    it "clears basket field if it is less than two" do
      card.update_attributes(attempt: 2, basket: 1)
      old_basket = card.basket
      card.has_valid_attempt
      expect(card.basket).to eq 0
    end
  end
end
