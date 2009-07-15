class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|
      t.column :user_id,      :integer, :null=>false
      t.column :description,  :string,  :limit=>256, :null=>false
      t.column :url,          :string,  :limit=>256, :null=>true
      t.column :price,        :decimal, :null=>true
    end
    add_index :gifts, [:user_id]
  end

  def self.down
    drop_table :gifts
  end
end
