require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  test 'login or email defaults to empty string' do
    assert_equal '', Friendship.new().login_or_email
  end

  test 'create requires login or email' do
    model = Friendship.create
    assert_equal ['cannot be blank.'], model.errors[:login_or_email]
  end

  test 'create requires valid_user' do
    user  = create_user(:login => 'user')
    model = Friendship.create(:user => user, :login_or_email => 'foo')
    assert_equal ["'foo' not found."], model.errors[:base]
  end

  test 'create requires other' do
    user  = create_user(:login => 'user')
    model = Friendship.create(:user => user, :login_or_email => 'user')
    assert_equal ['You cannot befriend yourself.'], model.errors[:base]
  end

  test 'create prevents duplicates' do
    user   = create_user(:login => 'user')
    friend = create_user(:login => 'friend')
    user.befriend(friend)

    model = Friendship.create(:user => user, :login_or_email => 'friend')
    assert_equal ["'friend' is already your friend."], model.errors[:base]
  end

  test 'destroy' do
    user       = create_user(:login => 'user')
    friend     = create_user(:login => 'friend')
    friendship = nil

    assert_difference 'Friendship.count' do
      friendship = Friendship.create(:user => user, :friend => friend)
    end

    assert_difference 'Friendship.count', -1 do
      friendship.destroy
    end
  end

end
