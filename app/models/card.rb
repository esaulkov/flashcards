class Card < ActiveRecord::Base
  belongs_to :deck
  has_attached_file :image,
                    styles: { original: "360x360#", thumb: "100x100#" }

  before_create :set_review_date

  validates :original_text, :translated_text, :review_date, :deck,
            presence: true
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validate :check_translate

  scope :expired, -> { where("review_date <= ?", Date.today) }
  scope :random, -> { offset(rand(Card.expired.count)) }

  def check_answer(answer)
    if normalize(original_text) == normalize(answer)
      update_attributes(review_date: 3.days.from_now.to_date, attempt: 0)
      return true
    else
      return false
    end
  end

  def has_valid_attempt
    if attempt < 2
      self.increment!(:attempt)
      return true
    else
      update_attributes(attempt: 0)
      return false
    end
  end

  protected

  def set_review_date
    self.review_date = Date.today
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
