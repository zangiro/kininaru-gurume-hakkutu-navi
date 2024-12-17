class CreateOutherTags < ActiveRecord::Migration[8.0]
  def change
    create_table :outher_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
