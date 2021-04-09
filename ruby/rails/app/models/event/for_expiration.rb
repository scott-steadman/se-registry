class Event::ForExpiration < Event

  def self.find_expired_events(date=Time.now)
    Event.where(["event_date <= ?", date])
  end

  def self.expire_events(date=Time.now)
    find_expired_events(date).each do |event|
      event.advance_or_delete
      event.save!
      yield event if block_given?
    end
  end

end
