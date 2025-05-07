class RemoveForeignKeysFromPlaylists < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :playlists, :users
  end
end
