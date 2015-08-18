class CheckAnswer
  def initialize(params)
    @card = params[:card]
  end

  def call(answer, answer_time)
    typos = similarity(@card.original_text, answer)
    quality = quality_of_answer(@card.original_text,
                                typos,
                                @card.attempt,
                                answer_time)
    if quality > 2
      e_factor = @card.e_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
      e_factor = [e_factor, 1.3].max
      results = calculate_review_date(@card.repetition, e_factor, quality)
      @card.update(e_factor: e_factor,
                   review_date: results[:review_date],
                   repetition: results[:repetition],
                   attempt: 0)
      success = true
    elsif @card.attempt < 2
      @card.increment!(:attempt)
      success = false
    else
      results = calculate_review_date(@card.repetition, e_factor, quality)
      @card.update(review_date: results[:review_date],
                   repetition: results[:repetition],
                   attempt: 0)
      success = false
    end
    { success: success, typos: typos }
  end

  private

  def similarity(first_word, second_word)
    first_word = normalize(first_word)
    second_word = normalize(second_word)
    Levenshtein.distance(first_word, second_word)
  end

  def quality_of_answer(text, typos, attempt, answer_time)
    if typos < [text.size / 3.0, 1].max
      quality = 5 - attempt
      quality = [quality - 1, 3].max if answer_time.to_f > 30.0
    else
      quality = typos <= text.size ? (text.size / typos).floor : 0
    end
    quality
  end

  def calculate_review_date(repetition, e_factor, quality)
    if quality < 3
      repetition = 1
    elsif repetition == 1
      repetition = 6
    else
      repetition = (repetition * e_factor).round
    end
    { repetition: repetition, review_date: repetition.days.from_now }
  end

  def normalize(text)
    text.mb_chars.downcase.strip.wrapped_string
  end
end
