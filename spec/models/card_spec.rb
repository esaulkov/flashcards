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

  context "check_answer method with right answer" do
    let!(:card) { create(:card) }

    def check_time_period(basket)
      card.update_attributes(basket: basket)
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
    end

    it "updates review_date if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.review_date).to be > DateTime.current
    end

    it "updates review_date by different time" do
      (0..5).to_a.each do |basket|
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

    it "increases basket field if answer is right" do
      old_basket = card.basket
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.basket).to eq (old_basket + 1)
    end

    it "doesn't increase basket field if it has max value" do
      card.update_attributes(basket: Card::OPTIONS.size - 1)
      old_basket = card.basket
      answer = "Sehenswürdigkeit"
      card.check_answer(answer)
      expect(card.basket).to eq old_basket
    end
  end

  context "check_answer method with wrong answer" do
    let!(:card) { create(:card) }

    it "does not update review_date if answer is not equal to original_text" do
      review_date = card.review_date
      answer = "Sight"
      card.check_answer(answer)
      expect(card.review_date).to eq review_date
    end

    it "returns false if answer is not equal to original_text" do
      answer = "Sight"
      expect(card.check_answer(answer)).to eq false
    end

    it "increases attempt field if it is less than two and answer is wrong" do
      attempt_backup = card.attempt
      answer = "Sight"
      card.check_answer(answer)
      expect(card.attempt).to eq (attempt_backup + 1)
    end

    it "clears attempt field if it is equal two and answer is wrong" do
      card.update_attributes(attempt: 2)
      answer = "Sight"
      card.check_answer(answer)
      expect(card.attempt).to eq 0
    end

    it "decreases basket field if attempt field is equal two" do
      card.update_attributes(attempt: 2, basket: 3)
      old_basket = card.basket
      answer = "Sight"
      card.check_answer(answer)
      expect(card.basket).to eq (old_basket - 2)
    end

    it "clears basket field if it is less than two" do
      card.update_attributes(attempt: 2, basket: 1)
      answer = "Sight"
      card.check_answer(answer)
      expect(card.basket).to eq 0
    end
  end
end
