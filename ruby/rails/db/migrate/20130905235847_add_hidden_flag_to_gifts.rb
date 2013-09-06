class AddHiddenFlagToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :hidden, :boolean, :default => false
  end
end
