class AddPostalCode < ActiveRecord::Migration
  def self.up
    add_column      :users, :postal_code, :string, :limit=>16
    change_column   :users, :role,        :string, :limit=>32, :null=>false, :default=>'user'
  end

  def self.down
    remove_column :users, :postal_code
  end
end
