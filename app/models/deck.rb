class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, inverse_of: :deck, dependent: :destroy

  validates :name, presence: true

  def clear_current(user)
    Deck.where(user: user).update_all(current: false)
  end
end
