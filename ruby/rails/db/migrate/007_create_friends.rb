class CreateFriends < ActiveRecord::Migration[6.0]

  def change
    create_table :friends, :id => false do |t|
      t.belongs_to  :user,      :null => false, :foreign_key => true, :index => false
      t.bigint      :friend_id, :null => false

      t.foreign_key :users,     :column => :friend_id

      t.index [:user_id, :friend_id], :unique => true
      t.index :friend_id
    end
  end

end
