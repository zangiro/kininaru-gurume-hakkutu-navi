class CreateGenreTags < ActiveRecord::Migration[8.0]
  def change
    create_table :genre_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
