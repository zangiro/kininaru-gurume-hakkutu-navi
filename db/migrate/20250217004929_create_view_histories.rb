class CreateViewHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :view_histories do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
