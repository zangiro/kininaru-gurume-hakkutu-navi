class PostTasteTag < ApplicationRecord
  belongs_to :post
  belongs_to :taste_tag
  accepts_nested_attributes_for :taste_tag
end
