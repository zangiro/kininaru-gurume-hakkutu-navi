class PostGenreTag < ApplicationRecord
  belongs_to :post
  belongs_to :genre_tag
  accepts_nested_attributes_for :genre_tag
end
