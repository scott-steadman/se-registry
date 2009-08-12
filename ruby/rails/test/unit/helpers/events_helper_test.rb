require File.dirname(__FILE__) + '/../../test_helper'

class EventsHelperTest < ActionView::TestCase
  include EventsHelper

  def setup
    @user     = create_user
    @event    = create_event(:user=>@user)
    @occasion = create_occasion(:user=>@user)
    @reminder = create_reminder(:user=>@user)

    self.stubs(:page_user).returns(@user)
  end

  def protect_against_forgery?
    false
  end

  test 'new_event_links with occasion' do
    self.stubs(:event_type).returns(Occasion.name)
    assert_match new_user_occasion_path(page_user), new_event_links
  end

  test 'new_event_links with reminder' do
    self.stubs(:event_type).returns(Reminder.name)
    assert_match new_user_reminder_path(page_user), new_event_links
  end

  test 'new_event_links with other' do
    self.stubs(:event_type).returns(Event.name)
    assert_match new_user_occasion_path(page_user), new_event_links
    assert_match new_user_reminder_path(page_user), new_event_links
  end


  test 'event_actions with occasion' do
    self.stubs(:event_type).returns(Occasion.name)
    assert_match edit_user_occasion_path(page_user, @occasion), event_actions(@occasion), 'Invalid edit URL'
    assert_match user_occasion_path(page_user, @occasion), event_actions(@occasion), 'Invalid delete URL'
  end

  test 'event_actions with reminder' do
    self.stubs(:event_type).returns(Reminder.name)
    assert_match edit_user_reminder_path(page_user, @reminder), event_actions(@reminder), 'Invalid edit URL'
    assert_match user_reminder_path(page_user, @reminder), event_actions(@reminder), 'Invalid delete URL'
  end

  test 'event_actions with other' do
    self.stubs(:event_type).returns(Event.name)
    assert_match edit_user_event_path(page_user, @event), event_actions(@event), 'Invalid edit URL'
    assert_match user_event_path(page_user, @event), event_actions(@event), 'Invalid delete URL'
  end

  test 'user_event_path with occasion' do
    self.stubs(:event_type).returns(Occasion.name)
    assert_equal user_occasion_path(@user, @event), user_event_path(@user, @event)
  end

  test 'user_event_path with reminder' do
    self.stubs(:event_type).returns(Reminder.name)
    assert_equal user_reminder_path(@user, @event), user_event_path(@user, @event)
  end

  test 'user_event_path with other' do
    self.stubs(:event_type).returns(Event.name)
    assert_equal "/users/#{@user.id}/events/#{@event.id}", user_event_path(@user, @event)
  end

end
