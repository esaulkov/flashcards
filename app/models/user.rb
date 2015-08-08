class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentication_class = Authentication
  end

  has_many :decks, inverse_of: :user, dependent: :destroy
  belongs_to :current_deck, class_name: "Deck"
  has_many :cards, through: :decks
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
            length: { minimum: 6 },
            confirmation: true,
            if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def has_linked_with?(provider)
    authentications.where(provider: provider).present?
  end

  def card_for_review
    if current_deck.present?
      current_deck.cards.expired.random.first
    else
      cards.expired.random.first
    end
  end

  protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end  
end
