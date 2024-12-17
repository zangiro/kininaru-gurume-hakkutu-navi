class CreatePostAreaTags < ActiveRecord::Migration[8.0]
  def change
    create_table :post_area_tags do |t|
      t.references :post, foreign_key: true
      t.references :area_tag, foreign_key: true

      t.timestamps
    end
  end
end
