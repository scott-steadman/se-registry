class CreateGivings < ActiveRecord::Migration
  def self.up
    create_table :givings, :id => false do |t|
      t.column :user_id,  :integer, :null => false
      t.column :gift_id,  :integer, :null => false
      t.column :intent,   :string,  :limit => 4, :default => 'will', :null => false # will,may
    end

    add_index :givings, [:user_id, :gift_id], :unique => true

    add_column :gifts, :multi, :boolean, :default => false
  end

  def self.down
    drop_table :givings
    remove_column :gifts, :multi
  end
end
