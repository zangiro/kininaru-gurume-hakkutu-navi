class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }

  belongs_to :user
  has_one :dish, dependent: :destroy
  accepts_nested_attributes_for :dish
end
