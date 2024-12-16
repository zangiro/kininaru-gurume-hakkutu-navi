class PostAreaTag < ApplicationRecord
  belongs_to :post
  belongs_to :area_tag
  accepts_nested_attributes_for :area_tag
end
