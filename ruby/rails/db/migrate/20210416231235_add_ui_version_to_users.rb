class AddUiVersionToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ui_version, :integer, :null => true
  end
end
