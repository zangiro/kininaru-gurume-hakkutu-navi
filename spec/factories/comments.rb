FactoryBot.define do
  factory :comment do
    body { "コメントA" }

    association :user
    association :post
  end
end
