require 'test_helper'

class User::ForNotifyingTest < ActiveSupport::TestCase

  test 'find_needs_reminding' do
    u = create_user(:lead_frequency => 1)
    u.reminders.create!(:description => 'Reminder 1', :event_date => Date.tomorrow)
    u.reminders.create!(:description => 'Reminder 2', :event_date => Date.tomorrow)

    users = User::ForNotifying.find_needs_reminding
    assert_equal 1, users.size

    # ensure number of reminders loaded
    assert_equal 2, users[0].reminders.size
  end

  test 'find_has_occasions none' do
    assert_equal 0, User::ForNotifying.find_has_occasions.size
  end

  test 'find_has_occasions' do
    u = create_user
    u.occasions.create!(:description => 'Occasion 1', :event_date => Date.tomorrow)
    u.occasions.create!(:description => 'Occasion 2', :event_date => Date.tomorrow)
    create_user(:login => 'friend', :lead_frequency => 1).befriend(u)

    users = User::ForNotifying.find_has_occasions
    assert_equal 1, users.size
    remindee =  users[0]
    assert_equal 1, remindee.friends.size
    friend = remindee.friends[0]
    assert_equal 2, friend.occasions.size
  end

private

  def create_user(attrs={})
    super(attrs.merge(:class => User::ForNotifying))
  end

end # class User::ForNotifyingTest
