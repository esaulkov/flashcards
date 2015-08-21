require "rails_helper"

describe SuperMemo do
  let(:object) { SuperMemo.new }

  context "calculate method" do
    context "with typos equal zero" do
      it "increases repetition" do
        text = "Sehenswürdigkeit"
        typos = 0
        attempt = 0
        answer_time = "12.0"
        repetition = 6
        e_factor = 2.5
        results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
        expect(results[:repetition]).to be > repetition
      end

      it "increases e-factor" do
        text = "Sehenswürdigkeit"
        typos = 0
        attempt = 0
        answer_time = "12.0"
        repetition = 6
        e_factor = 2.5
        results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
        expect(results[:e_factor]).to be > e_factor
      end

      it "returns success = true" do
        text = "Sehenswürdigkeit"
        typos = 0
        attempt = 0
        answer_time = "12.0"
        repetition = 6
        e_factor = 2.5
        results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
        expect(results[:success]).to eq true
      end

      context "with repetition equal one" do
        it "returns repetition = 6" do
          text = "Sehenswürdigkeit"
          typos = 0
          attempt = 0
          answer_time = "12.0"
          repetition = 1
          e_factor = 2.5
          results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
          expect(results[:repetition]).to eq 6
        end
      end

      context "when answer time is more than 30 seconds" do
        it "decreases quality of answer" do
          text = "Sehenswürdigkeit"
          typos = 0
          attempt = 0
          answer_time = "31.0"
          repetition = 1
          e_factor = 2.5
          results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
          expect(results[:e_factor]).to eq e_factor
        end
      end
    end

    context "when typos count is equal or more than text.size / 3" do
      it "returns success = false" do
        text = "Zimmer"
        typos = 2
        attempt = 0
        answer_time = "12.0"
        repetition = 1
        e_factor = 2.5
        results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
        expect(results[:success]).to eq false
      end

      it "returns repetition interval = 1" do
        text = "Fahrrad"
        typos = 3
        attempt = 0
        answer_time = "12.0"
        repetition = 1
        e_factor = 2.5
        results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
        expect(results[:repetition]).to eq 1
      end
    end

    context "when typos count is less than text.size / 3" do
      it "returns success = true" do
        text = "Fahrrad"
        typos = 2
        attempt = 0
        answer_time = "12.0"
        repetition = 1
        e_factor = 2.5
        results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
        expect(results[:success]).to eq true
      end
    end

    it "does not change e-factor less than 1.3" do
      text = "Fahrrad"
      typos = 0
      attempt = 2
      answer_time = "12.0"
      repetition = 1
      e_factor = 1.4
      results = object.calculate(text, typos, attempt, answer_time, repetition, e_factor)
      expect(results[:e_factor]).to eq 1.3
    end
  end
end
