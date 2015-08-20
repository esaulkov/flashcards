class SuperMemo
  def calculate(text, typos, attempt, answer_time, repetition, e_factor)
    quality = quality_of_answer(text, typos, attempt, answer_time)
    if quality > 2
      results = define_repetition_interval(repetition, e_factor, quality)
      results[:success] = true
      results[:review_date] = results[:repetition].days.from_now
    else
      results = { success: false, repetition: 1, review_date: 1.day.from_now }
    end
    results
  end

  private

  def quality_of_answer(text, typos, attempt, answer_time)
    if typos < [text.size / 3.0, 1].max
      quality = 5 - attempt
      quality = [quality - 1, 3].max if answer_time.to_f > 30.0
    else
      quality = typos <= text.size ? [(text.size / typos).floor, 2].min : 0
    end
    quality
  end

  def define_repetition_interval(repetition, e_factor, quality)
    new_efactor = find_efactor(e_factor, quality)
    interval = repetition == 1 ? 6 : (repetition * new_efactor).round
    { e_factor: new_efactor, repetition: interval }
  end

  # according SM-2 algorithm (http://www.supermemo.com/english/ol/sm2.htm)
  def find_efactor(e_factor, quality)
    e_factor = e_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    [e_factor, 1.3].max
  end
end
