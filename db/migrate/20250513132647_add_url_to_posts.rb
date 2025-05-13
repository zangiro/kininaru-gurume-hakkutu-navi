class AddUrlToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :source_url, :string
    add_column :posts, :store, :string
  end
end
