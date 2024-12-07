class CreateDishes < ActiveRecord::Migration[8.0]
  def change
    create_table :dishes do |t|
      t.string :introduction
      t.text :description, null: false
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
