require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'user creation' do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  test 'login required' do
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:login => nil)
    end
    assert_match 'Login is too short', ex.message
  end

  test 'login cannot be email' do
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:login => 'me@here.com', :email => 'me@here.com')
    end
    assert_match 'cannot be an email', ex.message
  end

  test 'password required' do
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:password => nil)
    end
    assert_match 'Password is too short', ex.message
  end

  test 'password confirmation required' do
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:password_confirmation => nil)
    end
    assert_match 'Password confirmation is too short', ex.message
  end

  test 'email required' do
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:email => nil)
    end
    assert_match 'Email is too short', ex.message
  end

  test 'email must be correct format' do
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:email => 'invalid')
    end
    assert_match 'should look like an email address', ex.message
  end

  test 'role defaults to user' do
    assert_equal 'user', User.new.role
  end

  test 'admin?' do
    assert create_user(:role=>'admin').admin?
  end

  test 'role mass update denied' do
    u = create_user
    assert u.update(:role => 'foo')
    assert 'user', u.role
  end

  test 'befriend' do
    user = create_user(:login=>'quentin')
    friend = create_user(:login=>'friend')
    user.befriend(friend)
    assert_equal 1, user.reload.friends.size
  end

  test 'destroy removes gifts' do
    user = create_user('user')
    user.gifts.create!(:description => 'gift')
    assert_difference 'Gift.count', -1 do
      user.destroy
    end
  end

  test 'destroy removes events' do
    user = create_user('user')
    user.occasions.create!(:description => 'occasion', :event_date => Date.today)
    user.reminders.create!(:description => 'reminder', :event_date => Date.today)
    assert_difference 'Event.count', -2 do
      user.destroy
    end
  end

  test 'destroy removes givings' do
    user   = create_user(:login=>'user')
    friend = create_user(:login=>'friend')
    gift   = friend.gifts.create!(:description => 'gift')
    user.befriend(friend)
    user.give(gift)

    assert_difference 'Giving.count', -1 do
      user.destroy
    end
  end

  test 'destroy removes friendships' do
    user = create_user(:login=>'user')
    friend = create_user(:login=>'friend')
    user.befriend(friend)

    assert_difference 'Friendship.count', -1 do
      friend.destroy
    end
  end

  test 'find_needs_reminding' do
    u = create_user(:lead_frequency => 1)
    u.reminders.create!(:description => 'Reminder 1', :event_date => Date.tomorrow)
    u.reminders.create!(:description => 'Reminder 2', :event_date => Date.tomorrow)

    users = User.find_needs_reminding
    assert_equal 1, users.size

    # ensure number of reminders loaded
    assert_equal 2, users[0].reminders.size
  end

  test 'find_has_occasions none' do
    assert_equal 0, User.find_has_occasions.size
  end

  test 'find_has_occasions' do
    u = create_user
    u.occasions.create!(:description => 'Occasion 1', :event_date => Date.tomorrow)
    u.occasions.create!(:description => 'Occasion 2', :event_date => Date.tomorrow)
    create_user(:login => 'friend', :lead_frequency => 1).befriend(u)

    users = User.find_has_occasions
    assert_equal 1, users.size
    remindee =  users[0]
    assert_equal 1, remindee.friends.size
    friend = remindee.friends[0]
    assert_equal 2, friend.occasions.size
  end

  test 'give' do
    giver = create_user
    gift  = create_gift
    giver.give(gift)
    assert gift.given?
  end

  # Issue 85
  test 'hidden gifts' do
    u = create_user
    u.gifts.create!(:description => 'visible')
    u.gifts.create!(:description => 'hidden', :hidden => true)

    assert_equal 2, u.gifts.count,         'there should be 2 gifts'
    assert_equal 1, u.visible_gifts.count, 'there should be 1 visible gift'
  end

end
