# == Schema Information
#
# Table name: events
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  description :string(64)      default(""), not null
#  event_type  :string(32)      default("occasion")
#  event_date  :date            not null
#  recur       :boolean(1)
#

class Reminder < Event
end
