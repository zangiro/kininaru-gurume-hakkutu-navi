class TasteTag < ApplicationRecord
  has_many :post_taste_tags, dependent: :destroy
  has_many :posts, through: :post_taste_tags
end
