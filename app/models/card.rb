class Card < ActiveRecord::Base
  before_create :set_review_date
  validates :original_text, :translated_text, :review_date, presence: true
  validate :check_translate

  protected

  def set_review_date
    self.review_date = 3.days.from_now.to_date
  end

  private

  def check_translate
    errors.add(:translated_text, :bad_translate) if original_text.mb_chars.downcase.strip == translated_text.mb_chars.downcase.strip
  end
end
