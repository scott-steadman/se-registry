class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends, :id=>false do |t|
      t.column :user_id, :integer, :null=>false
      t.column :friend_id, :integer, :null=>false
    end

    add_index :friends, :user_id
    add_index :friends, :friend_id
  end

  def self.down
    drop_table :friends
  end
end
