class AddAuthlogic < ActiveRecord::Migration
  def self.up
    remove_index  :users, :remember_token

    change_column :users, :crypted_password, :string, :limit=>255, :null=>false
    change_column :users, :salt,             :string, :limit=>255, :null=>false

    rename_column :users, :salt,           :password_salt
    rename_column :users, :remember_token, :persistence_token

    remove_column :users, :remember_token_expires_at
    remove_column :users, :activation_code
    remove_column :users, :activated_at

    add_column    :users, :current_login_at, :datetime
    add_column    :users, :last_login_at,    :datetime

    add_index     :users, :persistence_token
  end

  def self.down
    remove_index  :users, :persistence_token

    remove_column :users, :last_login_at
    remove_column :users, :current_login_at

    add_column    :users, :remember_token_expires_at, :datetime
    add_column    :users, :activation_code, :string, :length=>40
    add_column    :users, :activated_at, :datetime

    rename_column :users, :password_salt, :salt
    rename_column :users, :persistence_token, :remember_token

    change_column :users, :crypted_password, :string, :limit=>40, :null=>true
    change_column :users, :salt,             :string, :limit=>40, :null=>true

    add_index  :users, :remember_token
  end
end
