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
  self.inheritance_column = 'event_type'

  attr_accessible :description, :event_date, :recur

  validates_presence_of :description, :event_date

  belongs_to :user

  before_save :ensure_type

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

  def self.find_expired_events(date=Time.now)
    all(:conditions=>["event_date <= ?", date])
  end

  def self.expire_events(date=Time.now)
    find_expired_events(date).each do |event|
      event.advance_or_delete
      event.save!
      yield event if block_given?
    end
  end

private

  def ensure_type
    self.event_type ||= self.class.name
  end

end
