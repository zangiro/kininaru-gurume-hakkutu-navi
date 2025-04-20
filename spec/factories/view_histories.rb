FactoryBot.define do
  factory :view_history do
    association :user
    association :post
  end
end
