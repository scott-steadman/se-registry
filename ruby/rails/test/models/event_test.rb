require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test 'reminder' do
    create_reminder
    assert_equal Reminder, Event.first.class
  end

  test 'occasion' do
    create_occasion
    assert_equal Occasion, Event.first.class
  end

  test 'advance' do
    e = Event.new(:event_date => Time.now, :recur => true)
    e.advance_or_delete
    expected = Date.today >> 12
    assert_equal expected, e.event_date
  end

  test 'delete' do
    e = Event.new(:event_date => Time.now, :recur => false)
    e.expects(:destroy).times(1)
    e.advance_or_delete
    assert e.deleted?
  end

  test 'null dates deleted' do
    e = Event.new(:event_date => nil)
    e.expects(:destroy).times(1)
    e.advance_or_delete
    assert e.deleted?
  end

end
