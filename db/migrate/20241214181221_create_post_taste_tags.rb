class CreatePostTasteTags < ActiveRecord::Migration[8.0]
  def change
    create_table :post_taste_tags do |t|
      t.references :post, foreign_key: true
      t.references :taste_tag, foreign_key: true

      t.timestamps
    end
  end
end
