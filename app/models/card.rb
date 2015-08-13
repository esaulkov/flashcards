class Card < ActiveRecord::Base
  OPTIONS = [0, 0.5, 3, 7, 14, 30]

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

  def check_answer(answer)
    analogy = similarity(original_text, answer)
    if answer_is_correct?(original_text, analogy)
      new_basket = [basket + 1, OPTIONS.size - 1].min
      update_review(new_basket)
      return [true, analogy]
    elsif attempt < 2
      self.increment!(:attempt)
      return [false, 0]
    else
      new_basket = [basket - 2, 0].max
      update_review(new_basket)
      return [false, 0]
    end
  end

  protected

  def set_review_date
    self.review_date = DateTime.current
  end

  def update_review(new_basket)
    time_period = OPTIONS[new_basket].days.from_now
    update(basket: new_basket, review_date: time_period, attempt: 0)
  end

  private

  def check_translate
    if normalize(original_text) == normalize(translated_text)
      errors.add(:translated_text, :bad_translate)
    end
  end

  def similarity(first, second)
    first = normalize(first)
    second = normalize(second)
    Levenshtein.distance(first, second)
  end

  def answer_is_correct?(text, analogy)
    analogy < [text.size / 3.0, 1].max
  end

  def normalize(text)
    text.mb_chars.downcase.strip.wrapped_string
  end
end
