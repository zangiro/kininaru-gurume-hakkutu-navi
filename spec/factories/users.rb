FactoryBot.define do
  factory :user do
    name { "Aさん" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    agree_terms { "1" }
  end
end
