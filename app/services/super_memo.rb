class SuperMemo
  def initialize(card)
    @card = card
  end

  def calculate(answer, answer_time)
    typos = similarity(@card.original_text, answer)
    quality = quality_of_answer(@card.original_text,
                                typos,
                                @card.attempt,
                                answer_time)
    if quality > 2
      params = define_repetition_interval(@card.repetition,
                                          @card.e_factor,
                                          quality)
      success = update_card(@card, params)
    elsif @card.attempt < 2
      @card.increment!(:attempt)
      success = false
    else
      success = update_card(@card, repetition: 1)
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

  def update_card(card, params)
    params[:review_date] = params[:repetition].days.from_now
    params[:attempt] = 0
    card.update(params)
    params[:e_factor].present?
  end

  def normalize(text)
    text.mb_chars.downcase.strip.wrapped_string
  end
end
