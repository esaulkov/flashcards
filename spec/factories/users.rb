FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    salt "asdasdastr4325234324sdfds"
    password_confirmation { password }
  end
end
