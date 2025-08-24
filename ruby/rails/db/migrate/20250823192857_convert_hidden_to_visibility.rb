class ConvertHiddenToVisibility < ActiveRecord::Migration[7.1]
  def up
    add_column :gifts, :visibility, :text, default: nil
    Gift.reset_column_information
    Gift.update_all("visibility = CASE WHEN hidden THEN 'hidden' ELSE NULL END")
    remove_column :gifts, :hidden
  end

  def down
      add_column :gifts, :hidden, :boolean, default: false
      Gift.reset_column_information
      Gift.update_all("hidden = (visibility = 'hidden')")
      remove_column :gifts, :visibility
  end
end
