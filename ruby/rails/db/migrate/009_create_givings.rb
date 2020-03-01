class CreateGivings < ActiveRecord::Migration[6.0]

  def change
    create_table :givings, :id => false do |t|
      t.belongs_to :user,   :foreign_key => true
      t.belongs_to :gift,   :foreign_key => true
      t.string     :intent, :null => false,  :default => 'will' # will,may

      t.index [:user_id, :gift_id], :unique => true
    end
  end

end
