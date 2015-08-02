class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentication_class = Authentication
  end

  has_many :cards, inverse_of: :user, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
            length: { minimum: 6 },
            confirmation: true
  validates :password_confirmation, presence: true

  def has_linked_with(provider)
    authentications.where(provider: provider).present?
  end
end
