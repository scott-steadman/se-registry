class CreateEvents < ActiveRecord::Migration[6.0]

  def change
    create_table :events do |t|
      t.belongs_to  :user,        :foreign_key => true
      t.string      :description, :null => false
      t.string      :event_type,  :default => "Event" # ['Event', 'Occasion', 'Reminder']
      t.date        :event_date,  :null => false
      t.boolean     :recur,       :default => false
    end

    change_table :users do |t|
      t.integer  :lead_time,      :default => 10
      t.integer  :lead_frequency, :default => 10
    end
  end

end
