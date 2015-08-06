class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, inverse_of: :deck, dependent: :destroy

  def current?
    user.current_deck.present? && user.current_deck == self
  end

  def clear_current(user)
    Deck.where(user: user).update_all(current: false)
  end
end
