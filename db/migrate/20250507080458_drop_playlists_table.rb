class DropPlaylistsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :playlists
  end
end
