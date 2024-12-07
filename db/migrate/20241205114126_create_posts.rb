class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :source
      t.string :store_url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
