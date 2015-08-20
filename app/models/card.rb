class Card < ActiveRecord::Base
  belongs_to :deck
  has_attached_file :image,
                    styles: { original: "360x360#", thumb: "100x100#" }

  validates :original_text, :translated_text, :review_date, :deck,
            presence: true
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validate :check_translate

  before_create :set_review_date

  scope :expired, -> { where("review_date <= ?", DateTime.current) }
  scope :random, -> { offset(rand(Card.expired.count)) }

  def check_answer(answer, answer_time)
    typos = similarity(original_text, answer)
    results = SuperMemo.new.calculate(original_text,
                                      typos,
                                      attempt,
                                      answer_time,
                                      repetition,
                                      e_factor)
    success = results.delete(:success)
    results[:attempt] = 0
    if success
      update(results)
    elsif attempt < 2
      self.increment!(:attempt)
    else
      update(results)
    end
    { success: success, typos: typos }
  end

  protected

  def set_review_date
    self.review_date = DateTime.current
  end

  private

  def similarity(first_word, second_word)
    first_word = normalize(first_word)
    second_word = normalize(second_word)
    Levenshtein.distance(first_word, second_word)
  end

  def check_translate
    if normalize(original_text) == normalize(translated_text)
      errors.add(:translated_text, :bad_translate)
    end
  end

  def normalize(text)
    text.mb_chars.downcase.strip.wrapped_string
  end
end
