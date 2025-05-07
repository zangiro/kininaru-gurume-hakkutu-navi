class DropPostPlaylistsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :post_playlists
  end
end
