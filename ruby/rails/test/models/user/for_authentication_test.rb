require 'test_helper'

class User::ForAuthenticationTest < ActiveSupport::TestCase

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

private

  def create_user(attrs={})
    attrs[:password] = 'my password' unless attrs.has_key?(:password)

    super(attrs)
  end

end
