class RemoveForeignKeysFromPostPlaylists < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :post_playlists, :posts
    remove_foreign_key :post_playlists, :playlists
  end
end
