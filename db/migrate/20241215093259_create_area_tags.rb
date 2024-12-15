class CreateAreaTags < ActiveRecord::Migration[8.0]
  def change
    create_table :area_tags do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
