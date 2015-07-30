FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    salt "asdasdastr4325234324sdfds"

    after_build do |user|
      user.crypted_password = Sorcery::CryptoProviders::BCrypt.encrypt(user.password, user.salt)
    end
  end
end
