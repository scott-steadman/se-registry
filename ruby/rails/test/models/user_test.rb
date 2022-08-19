require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'role defaults to user' do
    assert_equal 'user', User.new.role
  end

  test 'admin?' do
    assert create_user(:role=>'admin').admin?
  end

  test 'role mass update denied' do
    u = create_user
    assert u.update(:role => 'foo')
    assert_equal 'foo', u.role
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

  test 'give' do
    giver = create_user
    gift  = create_gift(:class => Gift::ForGiving)
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
