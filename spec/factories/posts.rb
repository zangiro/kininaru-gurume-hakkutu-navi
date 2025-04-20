FactoryBot.define do
  factory :post do
    title { "記事A" }
    after(:build) do |post|
      post.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/1.jpg')), filename: '1.jpg', content_type: 'image/jpeg')
    end

    association :user
  end
end
