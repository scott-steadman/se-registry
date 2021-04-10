# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  description :string           not null
#  event_type  :string           default("Event")
#  event_date  :date             not null
#  recur       :boolean          default(FALSE)
#

class Occasion < Event
end
