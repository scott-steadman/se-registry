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

class Event < ActiveRecord::Base
  inheritence_column = :event_type

  belongs_to :user

  def deleted?
    return @deleted
  end

  def advance_or_delete
    if recur? && event_date
      self.event_date = event_date.to_date >> 12
    else
      self.destroy
      @deleted = true
    end
  end

  def self.find_expired_events(date=Time.now)
    find(:all, :conditions=>["event_date <= ?", date])
  end

  def self.expire_events(date=Time.now)
    find_expired_events(date).each do |event|
      event.advance_or_delete
      event.save!
      yield event if block_given?
    end
  end


end
