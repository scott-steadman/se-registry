class CreateGifts < ActiveRecord::Migration[6.0]

  def change
    create_table :gifts do |t|
      t.belongs_to  :user ,        :foreign_key => true
      t.string      :description,  :null => false
      t.string      :url,          :null => true
      t.boolean     :multi,        :default => false
      t.boolean     :hidden,       :default => false
      t.float       :price,        :precision => 10, :scale => 2, :null => true
      t.timestamps                 :null => true
    end
  end

end
