class UpdateTables < ActiveRecord::Migration
  def self.up
    Event.connection.execute(%q{update events set event_type='Occasion' where event_type='occasion'})
    Event.connection.execute(%q{update events set event_type='Reminder' where event_type='reminder'})
    change_column :events, :event_type, :string, :limit=>64, :default=>nil
  end

  def self.down
    Event.connection.execute(%q{update events set event_type='occasion' where event_type='Occasion'})
    Event.connection.execute(%q{update events set event_type='reminder' where event_type='Reminder'})
    change_column :events, :event_type, :string, :limit=>32, :default=>'occasion'
  end
end
