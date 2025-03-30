class CreateDishes < ActiveRecord::Migration[7.2]
  def change
    create_table :dishes do |t|
      t.string :introduction
      t.text :description, null: false
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
