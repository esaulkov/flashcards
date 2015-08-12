class Card < ActiveRecord::Base
  OPTIONS = [0, 0.5, 3, 7, 14, 30]

  belongs_to :deck
  has_attached_file :image,
                    styles: { original: "360x360#", thumb: "100x100#" }

  before_create :set_review_date

  validates :original_text, :translated_text, :review_date, :deck,
            presence: true
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validate :check_translate

  scope :expired, -> { where("review_date <= ?", DateTime.now) }
  scope :random, -> { offset(rand(Card.expired.count)) }

  def check_answer(answer)
    if normalize(original_text) == normalize(answer)
      new_basket = basket < OPTIONS.size - 1 ? basket + 1 : basket
      update_review(new_basket)
      return true
    else
      return false
    end
  end

  def check_attempt
    if attempt < 2
      self.increment!(:attempt)
      return true
    else
      new_basket = basket > 1 ? basket - 2 : 0
      update_review(new_basket)
      return false
    end
  end

  protected

  def set_review_date
    self.review_date = DateTime.now
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

  def normalize(text)
    text.mb_chars.downcase.strip
  end
end
