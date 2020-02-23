# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  description :string(64)       not null
#  event_type  :string(64)
#  event_date  :date             not null
#  recur       :boolean          default("0")
#  created_at  :datetime
#  updated_at  :datetime
#

class Occasion < Event
end
