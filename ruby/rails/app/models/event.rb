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

class Event < ApplicationRecord
  self.inheritance_column = 'event_type'

  validates_presence_of :description, :event_date

  belongs_to :user

  def deleted?
    return @deleted
  end

  def advance_or_delete
    if recur? && event_date
      self.event_date = event_date.to_date >> 12
    else
      destroy
      @deleted = true
    end
  end

  def date
    event_date
  end

  def date=(value)
    self.event_date = value
  end

end
