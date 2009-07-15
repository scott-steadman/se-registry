class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :user_id, :integer, :null=>false
      t.column :description, :string, :limit=>64, :null=>false
      t.column :event_type, :string, :limit=>32, :default=>"occasion" # ['occasion', 'reminder']
      t.column :event_date, :date, :null=>false
      t.column :recur, :boolean, :default=>false
    end

    add_column  :users, :lead_time, :integer, :null=>true, :default=>10
    add_column  :users, :lead_frequency, :integer, :null=>false, :default=>10
  end

  def self.down
    drop_table :events
    remove_column :users, :lead_time
    remove_column :users, :lead_frequency
  end
end
