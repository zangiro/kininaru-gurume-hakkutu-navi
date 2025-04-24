FactoryBot.define do
  factory :dish do
    description { "説明A" }

    association :post
  end
end
