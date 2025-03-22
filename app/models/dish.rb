class Dish < ApplicationRecord
  validates :description, presence: true

  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    [ "description" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "post" ]
  end
end
