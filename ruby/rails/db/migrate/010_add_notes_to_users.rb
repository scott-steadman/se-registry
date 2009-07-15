class AddNotesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notes, :string
  end

  def self.down
    remove_column :users, :notes
  end
end
