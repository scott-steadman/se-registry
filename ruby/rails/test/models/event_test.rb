require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def test_reminder
    create_reminder
    assert_equal Reminder, Event.first.class
  end

  def test_occasion
    create_occasion
    assert_equal Occasion, Event.first.class
  end

  def test_advance
    e = Event.new(:event_date => Time.now, :recur => true)
    e.advance_or_delete
    expected = Date.today >> 12
    assert_equal expected, e.event_date
  end

  def test_delete
    e = Event.new(:event_date => Time.now, :recur => false)
    e.expects(:destroy).times(1)
    e.advance_or_delete
    assert e.deleted?
  end

  def test_null_dates_deleted
    e = Event.new(:event_date => nil)
    e.expects(:destroy).times(1)
    e.advance_or_delete
    assert e.deleted?
  end

end
