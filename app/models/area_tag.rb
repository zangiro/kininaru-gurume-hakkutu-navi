class AreaTag < ApplicationRecord
  validates :name, presence: true

  has_many :post_area_tags, dependent: :destroy
  has_many :posts, through: :post_area_tags
end
