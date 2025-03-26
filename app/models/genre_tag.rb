class GenreTag < ApplicationRecord
  has_many :post_genre_tags, dependent: :destroy
  has_many :posts, through: :post_genre_tags

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "post" ]
  end
end
