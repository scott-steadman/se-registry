require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveRecord::TestCase

  test 'user creation' do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:login => nil)
    end
    assert_match 'Login is too short', ex.message
  end

  def test_should_require_password
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:password => nil)
    end
    assert_match 'Password is too short', ex.message
  end

  def test_should_require_password_confirmation
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:password_confirmation => nil)
    end
    assert_match 'Password confirmation is too short', ex.message
  end

  def test_should_require_email
    ex = assert_raise ActiveRecord::RecordInvalid do
      create_user(:email => nil)
    end
    assert_match 'Email is too short', ex.message
  end

  def test_role_defaults_to_user
    assert_equal 'user', User.new.role
  end

  def test_admin?
    assert create_user(:role=>'admin').admin?
  end

  def test_should_not_allow_role_mass_update
    u = create_user
    assert u.update_attributes(:role => 'foo')
    assert 'user', u.role
  end

  test 'befriend' do
    user = create_user(:login=>'quentin')
    friend = create_user(:login=>'friend')
    user.befriend(friend)
    assert_equal 1, user.reload.friends.size
  end

  def test_friend_removed_on_destroy
    user = create_user(:login=>'user')
    friend = create_user(:login=>'friend')
    user.befriend(friend)
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

  test 'find_has_occasions none' do
    assert_equal 0, User.find_has_occasions.size
  end

  test 'find_has_occasions' do
    u = create_user
    u.occasions.create(:description=>'Occasion 1', :event_date=>Date.tomorrow)
    u.occasions.create(:description=>'Occasion 2', :event_date=>Date.tomorrow)
    create_user('friend').befriend(u)

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

end
