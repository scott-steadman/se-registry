class RemoveOpenId < ActiveRecord::Migration
  def self.up
    drop_table :open_id_associations
    drop_table :open_id_nonces
    drop_table :open_id_settings
    remove_column :users, :open_id_url
  end

  def self.down
  end
end
