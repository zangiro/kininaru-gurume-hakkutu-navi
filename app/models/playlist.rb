class Playlist < ApplicationRecord
  has_many :post_playlists, dependent: :destroy
  has_many :posts, through: :post_playlists
end
