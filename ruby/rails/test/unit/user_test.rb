# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(255)
#  email             :string(255)
#  crypted_password  :string(255)     default(""), not null
#  password_salt     :string(255)     default(""), not null
#  created_at        :datetime
#  updated_at        :datetime
#  persistence_token :string(255)
#  role              :string(32)      default("user"), not null
#  postal_code       :string(16)
#  lead_time         :integer(4)
#  lead_frequency    :integer(4)      default(1), not null
#  notes             :string(255)
#  current_login_at  :datetime
#  last_login_at     :datetime
#

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
