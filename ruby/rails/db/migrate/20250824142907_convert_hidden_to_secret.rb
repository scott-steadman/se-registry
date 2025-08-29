class ConvertHiddenToSecret < ActiveRecord::Migration[7.1]
  def up
    Gift.where(visibility: 'hidden').update_all(visibility: 'secret')
  end
  def down
    Gift.where(visibility: 'secret').update_all(visibility: 'hidden')
  end
end
