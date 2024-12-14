class GenreTag < ApplicationRecord
  has_many :post_genre_tags, dependent: :destroy
  has_many :posts, through: :post_genre_tags
end
