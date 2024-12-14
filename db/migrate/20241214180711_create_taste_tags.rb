class CreateTasteTags < ActiveRecord::Migration[8.0]
  def change
    create_table :taste_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
