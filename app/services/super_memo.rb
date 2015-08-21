class SuperMemo
  # success = true if quality of answer is in range 3..5
  # else success = false and next repetition interval equal one day
  def calculate(text, typos, attempt, answer_time, repetition, e_factor)
    quality = find_quality_of_answer(text, typos, attempt, answer_time)
    if quality > 2
      new_efactor = find_efactor(e_factor, quality)
      interval = find_repetition_interval(repetition, new_efactor)
      { success: true, repetition: interval,
        review_date: repetition.days.from_now, e_factor: new_efactor }
    else
      { success: false, repetition: 1, review_date: 1.day.from_now }
    end
  end

  private

  # answer is right if there is less than one typo for three letters in text
  # in this case:
  # quality = 5 if it is first attempt
  # quality = 4 if it is second attempt
  # quality = 3 if it is third attempt
  # quality is lesser if answer_time > 30 seconds
  # else quality is in range 0..2.
  # quality = 2 if typos <= half of text size
  # quality = 1 if typos <= text size
  # quality = 0 if typos > text size
  def find_quality_of_answer(text, typos, attempt, answer_time)
    if typos < text.size / 3.0
      quality = 5 - attempt
      quality = [quality - 1, 3].max if answer_time.to_f > 30.0
    else
      quality = [(text.size / typos).floor, 2].min
    end
    quality
  end

  # first repetition interval equal 1
  # second repetition interval equal 6
  # next interval equal previous interval * e_factor
  def find_repetition_interval(repetition, e_factor)
    return 6 if repetition == 1
    (repetition * e_factor).round
  end

  # according SM-2 algorithm (http://www.supermemo.com/english/ol/sm2.htm)
  def find_efactor(e_factor, quality)
    e_factor = e_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    [e_factor, 1.3].max
  end
end
