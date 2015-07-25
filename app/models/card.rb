class Card < ActiveRecord::Base
  before_create :set_review_date
  validates :original_text, :translated_text, :review_date, presence: true
  validate :check_translate

  #scope :expired, -> { where("review_date <= ?", Date.today) }
  scope :expired, -> { where("review_date <= ?", 2.days.from_now.to_date) }
  scope :random, -> { offset(rand(Card.count)) }

  def check_answer(answer)
    if normalize(original_text) == normalize(answer)
      update_attributes(review_date: 3.days.from_now.to_date) and return true
    end
    return false
  end

  protected

  def set_review_date
    self.review_date = 3.days.from_now.to_date
  end

  private

  def check_translate
    if normalize(original_text) == normalize(translated_text)
      errors.add(:translated_text, :bad_translate)
    end
  end

  def normalize(text)
    text.mb_chars.downcase.strip
  end
end
