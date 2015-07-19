class Card < ActiveRecord::Base
  before_save :set_review_date
  validates :original_text, :translated_text, :review_date, presence: true
  validate :check_translate

  def has_correct_translate?
    original_text.downcase != translated_text.downcase    
  end

  protected
  def set_review_date
    self.review_date = 3.days.from_now.to_date
  end

  private
  def check_translate
    errors.add(:translated_text, :incorrect_translate) unless has_correct_translate?
  end
end
