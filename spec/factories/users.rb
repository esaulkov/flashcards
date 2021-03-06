FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    password_confirmation { password }
    locale :ru
  end
end
