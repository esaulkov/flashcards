class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, inverse_of: :deck, dependent: :destroy

  validates :name, presence: true

  def current?
    user.current_deck == self
  end
end
