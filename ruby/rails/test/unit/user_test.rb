require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveRecord::TestCase

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_authenticate_user
    u = create_user(:login=>'quentin', :password=>'test', :password_confirmation=>'test')
    assert_equal u, User.authenticate('quentin', 'test')
  end

  def test_should_reset_password
    u = create_user(:login=>'quentin', :password=>'test', :password_confirmation=>'test')
    u.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal u, User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    u = create_user(:login=>'quentin', :password=>'test', :password_confirmation=>'test')
    u.update_attributes(:login => 'quentin2')
    assert_equal u, User.authenticate('quentin2', 'test')
  end

  def test_role_defaults_to_user
    assert_equal 'user', create_user.role
  end

  def test_admin?
    assert create_user(:role=>'admin').admin?
  end

  def test_should_not_allow_role_mass_update
    u = create_user
    assert u.update_attributes(:role => 'foo')
    assert 'user', u.role
  end

  def test_befriending
    user = create_user(:login=>'quentin')
    friend = create_user(:login=>'friend')
    user.friends << friend
    user.save
    user.reload
    assert_equal 1, user.friends.size
  end

  def test_friend_removed_on_destroy
    user = create_user(:login=>'user')
    friend = create_user(:login=>'friend')
    user.friends << friend
    user.save!

    assert_equal 1, user.friends.size
    friend.destroy
    user.reload
    assert_equal 0, user.friends.size
  end

  def test_find_needs_reminding
    u = create_user
    u.reminders.create(:description=>'Reminder 1', :event_date=>Date.tomorrow)
    u.reminders.create(:description=>'Reminder 2', :event_date=>Date.tomorrow)

    users = User.find_needs_reminding
    assert_equal 1, users.size

    # ensure number of reminders loaded
    assert_equal 2, users[0].reminders.size
  end

  def test_find_has_occasions_none
    assert_equal 0, User.find_has_occasions.size
  end

  def test_find_has_occasions
    u = create_user
    u.occasions.create(:description=>'Occasion 1', :event_date=>Date.tomorrow)
    u.occasions.create(:description=>'Occasion 2', :event_date=>Date.tomorrow)
    create_user('friend').friends << u

    users = User.find_has_occasions
    assert_equal 1, users.size
    remindee =  users[0]
    assert_equal 1, remindee.friends.size
    friend = remindee.friends[0]
    assert_equal 2, friend.occasions.size
  end

end
