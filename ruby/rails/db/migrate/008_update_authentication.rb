class UpdateAuthentication < ActiveRecord::Migration
  def self.up
    remove_index :users, [:identity_url]
    rename_column :users, :identity_url, :open_id_url
    add_index :users, [:open_id_url]

    rename_table :open_id_authentication_associations, :open_id_associations
    rename_table :open_id_authentication_nonces, :open_id_nonces
    rename_table :open_id_authentication_settings, :open_id_settings
  end

  def self.down
    remove_index :users, [:open_id_url]
    rename_column :users, :open_id_url, :identity_url
    add_index :users, [:identity_url]

    rename_table :open_id_associations, :open_id_authentication_associations
    rename_table :open_id_nonces, :open_id_authentication_nonces
    rename_table :open_id_settings, :open_id_authentication_settings
  end

end
