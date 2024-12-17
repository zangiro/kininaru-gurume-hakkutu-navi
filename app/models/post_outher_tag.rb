class PostOutherTag < ApplicationRecord
  belongs_to :post
  belongs_to :outher_tag
  accepts_nested_attributes_for :outher_tag
end
