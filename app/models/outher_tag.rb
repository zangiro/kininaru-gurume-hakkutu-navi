class OutherTag < ApplicationRecord
  has_many :post_outher_tags, dependent: :destroy
  has_many :posts, through: :post_outher_tags
end
