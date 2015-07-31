class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :cards, inverse_of: :user, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
            length: { minimum: 6 },
            confirmation: true
  validates :password_confirmation, presence: true
end
