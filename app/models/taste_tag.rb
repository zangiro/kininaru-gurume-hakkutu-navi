class TasteTag < ApplicationRecord
  has_many :post_taste_tags, dependent: :destroy
  has_many :posts, through: :post_taste_tags

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "post" ]
  end
end
