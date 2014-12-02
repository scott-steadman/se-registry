class AddTimestampsToModels < ActiveRecord::Migration
  def change
    add_timestamps :events
    add_timestamps :friends
    add_timestamps :gifts
    add_timestamps :givings
  end
end
