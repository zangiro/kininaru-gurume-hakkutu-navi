class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }

  belongs_to :user
  has_one :dish, dependent: :destroy
  accepts_nested_attributes_for :dish  # allow_destroy: true
  has_many :post_genre_tags, dependent: :destroy
  has_many :genre_tags, through: :post_genre_tags
  accepts_nested_attributes_for :post_genre_tags  # allow_destroy: true
  has_many :post_taste_tags, dependent: :destroy
  has_many :taste_tags, through: :post_taste_tags
  accepts_nested_attributes_for :post_taste_tags
end
