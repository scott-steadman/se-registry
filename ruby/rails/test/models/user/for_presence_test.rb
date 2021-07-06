require 'test_helper'

# Issue 31
class User::ForPresenceTest < ActiveSupport::TestCase


  # I want to make sure this works as expected
  test 'friends_to_notify' do
    user.friends << friend

    assert_equal [user], friend.friends_to_notify
  end

  test 'appear' do
    user.friends << friend

    PresenceChannel.expects(:broadcast_to)
    friend.appear
  end

  test 'disappear' do
    user.friends << friend

    PresenceChannel.expects(:broadcast_to)
    friend.disappear
  end

private

  def user
    @user ||= create_user(:login => 'user')
  end

  def friend
    @friend ||= create_user(:login => 'friend')
  end

  def create_user(attrs={})
    super(attrs.merge(:class => User::ForPresence))
  end

end # class User::ForPresenceTest
