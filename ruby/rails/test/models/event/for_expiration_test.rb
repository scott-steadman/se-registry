require 'test_helper'

class Event::ForExpirationTest < ActiveSupport::TestCase

  def test_find_expired_events
    create_occasion(:event_date => Time.now + 1.day)
    expired = Event::ForExpiration.find_expired_events(Time.now + 10.days)
    assert_equal 1, expired.size
    expired.each do |event|
      assert_operator(Time.now.to_date, :<, event.event_date)
    end
  end

  def test_expire_events
    create_occasion(:event_date => Time.now)
    expected = Event::ForExpiration.find_expired_events(Time.now + 10.days).count

    count = 0
    Event::ForExpiration.expire_events(Time.now + 10.days) do |event|
      assert_not_nil event
      count += 1
    end
    assert_equal expected, count

    result = Event::ForExpiration.find_expired_events(Time.now + 10.days)
    assert_not_equal expected, result.size
  end

end # class Event::ForExpirationTest
