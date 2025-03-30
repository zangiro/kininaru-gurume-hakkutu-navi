class ChangeUsersIsPublic < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :is_public, true
  end
end
