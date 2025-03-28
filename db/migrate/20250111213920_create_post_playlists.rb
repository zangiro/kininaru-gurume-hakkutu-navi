class CreatePostPlaylists < ActiveRecord::Migration[7.2]
  def change
    create_table :post_playlists do |t|
      t.references :post, foreign_key: true
      t.references :playlist, foreign_key: true

      t.timestamps
    end
  end
end
