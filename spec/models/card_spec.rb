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
    before(:each) { @answer_time = "10.0" }

    it "updates review_date if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      card.check_answer(answer, @answer_time)
      expect(card.review_date).to be > DateTime.current
    end

    it "returns true if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq true
    end

    it "returns true if answer is in other case" do
      answer = "seHenswürDigkeit"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq true
    end

    it "returns true if answer ends with blank symbol" do
      answer = "Sehenswürdigkeit "
      expect(card.check_answer(answer, @answer_time)[:success]).to eq true
    end

    it "returns true if answer begins with spaces" do
      answer = "  Sehenswürdigkeit"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq true
    end

    it "returns true if answer has typo" do
      answer = "Sehenswurdigkeit"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq true
    end

    it "returns true if answer has some typos" do
      card = create(:second_card)
      answer = "Farad"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq true
    end

    it "increases E-Factor attribute if attempt is equal zero" do
      old_efactor = card.e_factor
      answer = "Sehenswürdigkeit"
      card.check_answer(answer, @answer_time)
      expect(card.e_factor).to be > old_efactor
    end

    it "does not change E-Factor attribute if attempt is equal one" do
      old_efactor = card.e_factor
      card.update_attributes(attempt: 1)
      answer = "Sehenswürdigkeit"
      card.check_answer(answer, @answer_time)
      expect(card.e_factor).to eq old_efactor
    end

    it "decreases E-Factor attribute if attempt is equal two" do
      old_efactor = card.e_factor
      card.update_attributes(attempt: 2)
      answer = "Sehenswürdigkeit"
      card.check_answer(answer, @answer_time)
      expect(card.e_factor).to be < old_efactor
    end
  end

  context "check_answer method with wrong answer" do
    let!(:card) { create(:card) }
    before(:each) { @answer_time = "10.0" }

    it "does not update review_date if attempt is less than two" do
      old_review_date = card.review_date
      answer = "Sight"
      card.check_answer(answer, @answer_time)
      expect(card.review_date).to eq old_review_date
    end

    it "returns false if answer is not equal to original_text" do
      answer = "Sight"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq false
    end

    it "returns false if answer has too much typos" do
      card = create(:second_card)
      answer = "Farade"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq false
    end

    it "returns false if answer has typo but word is simple" do
      card = create(:card, original_text: "Акула", translated_text: "Hai")
      answer = "Hay"
      expect(card.check_answer(answer, @answer_time)[:success]).to eq false
    end

    it "increases attempt field if it is less than two and answer is wrong" do
      attempt_backup = card.attempt
      answer = "Sight"
      card.check_answer(answer, @answer_time)
      expect(card.attempt).to eq (attempt_backup + 1)
    end

    it "clears attempt field if it is equal two and answer is wrong" do
      card.update_attributes(attempt: 2)
      answer = "Sight"
      card.check_answer(answer, @answer_time)
      expect(card.attempt).to eq 0
    end

    it "sets repetition interval to one" do
      card.update_attributes(repetition: 3, attempt: 2)
      answer = "Sight"
      card.check_answer(answer, @answer_time)
      expect(card.repetition).to eq 1
    end

    it "does not update E-Factor attribute" do
      old_efactor = card.e_factor
      card.update_attributes(attempt: 2)
      answer = "Sight"
      card.check_answer(answer, @answer_time)
      expect(card.e_factor).to eq old_efactor
    end
  end
end
