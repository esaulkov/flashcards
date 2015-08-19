require "rails_helper"

describe SuperMemo do
  context "calculate method with right answer" do
    let!(:card) { create(:card) }

    before(:each) { @answer_time = "10.391" }

    it "returns true if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq true
    end

    it "updates review_date if answer is equal to original_text" do
      answer = "Sehenswürdigkeit"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.review_date).to be > DateTime.current
    end

    it "returns true if answer is in other case" do
      answer = "seHenswürDigkeit"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq true
    end

    it "returns true if answer ends with blank symbol" do
      answer = "Sehenswürdigkeit "
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq true
    end

    it "returns true if answer begins with spaces" do
      answer = "  Sehenswürdigkeit"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq true
    end

    it "returns true if answer has typo" do
      answer = "Sehenswurdigkeit"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq true
    end

    it "returns true if answer has some typos" do
      card = create(:second_card)
      answer = "Farad"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq true
    end

    it "increases repetition interval" do
      old_repetition = card.repetition
      answer = "Sehenswürdigkeit"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.repetition).to be > old_repetition
    end

    it "increases E-Factor attribute if attempt is equal zero" do
      old_efactor = card.e_factor
      answer = "Sehenswürdigkeit"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.e_factor).to be > old_efactor
    end

    it "does not change E-Factor attribute if attempt is equal one" do
      old_efactor = card.e_factor
      card.update_attributes(attempt: 1)
      answer = "Sehenswürdigkeit"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.e_factor).to eq old_efactor
    end

    it "decreases E-Factor attribute if attempt is equal two" do
      old_efactor = card.e_factor
      card.update_attributes(attempt: 2)
      answer = "Sehenswürdigkeit"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.e_factor).to be < old_efactor
    end

    it "decreases quality of answer if answer time is more than 30 seconds" do
      old_efactor = card.e_factor
      answer = "Sehenswürdigkeit"
      answer_time = "31.0"
      SuperMemo.new(card).calculate(answer, answer_time)
      expect(card.e_factor).to eq old_efactor
    end
  end

  context "calculate method with wrong answer" do
    let!(:card) { create(:card) }

    before(:each) { @answer_time = "10.391" }

    it "returns false if answer is not equal to original_text" do
      answer = "Sight"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq false
    end

    it "returns false if answer has too much typos" do
      card = create(:second_card)
      answer = "Farade"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq false
    end

    it "returns false if answer has typo but word is simple" do
      card = create(:card, original_text: "Акула", translated_text: "Hai")
      answer = "Hay"
      results = SuperMemo.new(card).calculate(answer, @answer_time)
      expect(results[:success]).to eq false
    end

    it "increases attempt field if it is less than two" do
      attempt_backup = card.attempt
      answer = "Sight"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.attempt).to eq (attempt_backup + 1)
    end

    it "clears attempt field if it is equal two" do
      card.update_attributes(attempt: 2)
      answer = "Sight"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.attempt).to eq 0
    end

    it "does not update review_date if attempt is less than three" do
      old_review_date = card.review_date
      answer = "Sight"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.review_date).to eq old_review_date
    end

    it "sets repetition interval to one" do
      card.update_attributes(repetition: 3, attempt: 2)
      answer = "Sight"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.repetition).to eq 1
    end

    it "does not update E-Factor attribute" do
      old_efactor = card.e_factor
      card.update_attributes(attempt: 2)
      answer = "Sight"
      SuperMemo.new(card).calculate(answer, @answer_time)
      expect(card.e_factor).to eq old_efactor
    end
  end
end
