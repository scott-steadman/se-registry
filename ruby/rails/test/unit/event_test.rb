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

require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveRecord::TestCase

  def test_advance
    e = Event.new(:event_date=>Time.now, :recur=>true)
    e.advance_or_delete
    expected = Date.today >> 12
    assert expected, e.event_date
  end

  def test_delete
    e = Event.new(:event_date=>Time.now, :recur=>false)
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

  def test_find_expired_events
    create_occasion(:event_date=>Time.now + 1.day)
    expired = Event.find_expired_events(Time.now + 10.days)
    assert_equal 1, expired.size
    expired.each do |event|
      assert_operator(Time.now.to_date, :<, event.event_date)
    end
  end

  def test_expire_events
    create_occasion(:event_date=>Time.now)
    expected = Event.find_expired_events(Time.now + 10.days)

    count = 0
    Event.expire_events(Time.now + 10.days) do |event|
      assert_not_nil event
      count += 1
    end
    assert_equal expected.size, count

    result = Event.find_expired_events(Time.now + 10.days)
    assert_not_equal expected.size, result.size
  end

end
