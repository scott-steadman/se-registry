require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < ActiveRecord::TestCase

  def test_login_or_email_defaults_to_empty_string
    assert_equal '', Friendship.new().login_or_email
  end

  def test_create_requires_login_or_email
    model = Friendship.create
    assert_equal "cannot be blank.", model.errors.on(:login_or_email)
  end

  def test_create_requires_valid_user
    user = create_user(:login=>'user')
    model = Friendship.create(:user=>user, :login_or_email=>'foo')
    assert_equal "'foo' not found.", model.errors.on_base
  end

  def test_create_requires_other
    user = create_user(:login=>'user')
    model = Friendship.create(:user=>user, :login_or_email=>'user')
    assert_equal "You cannot befriend yourself.", model.errors.on_base
  end

  def test_create_prevents_duplicates
    user = create_user(:login=>'user')
    friend = create_user(:login=>'friend')
    user.befriend(friend)

    model = Friendship.create(:user=>user, :login_or_email=>'friend')
    assert_equal "'friend' is already your friend.", model.errors.on_base
  end

  def test_destroy
    user = create_user(:login=>'user')
    friend = create_user(:login=>'friend')
    friendship = nil
    assert_difference 'Friendship.count' do
      friendship = Friendship.create(:user=>user, :friend=>friend)
    end

    assert_difference 'Friendship.count', -1 do
      friendship.destroy
    end
  end

end
