class Playlist < ApplicationRecord
  validates :title, presence: true

  belongs_to :user
  has_many :post_playlists, dependent: :destroy
  has_many :posts, through: :post_playlists
end
