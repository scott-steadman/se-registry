ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'authlogic/test_case'
require 'minitest/unit'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors) unless ENV['COVERAGE']

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_user(attrs={})
    attrs = {:login => attrs} if attrs.is_a?(String)

    attrs[:login]     = 'quire'                         unless attrs.has_key?(:login)
    attrs[:lead_time] = 10                              unless attrs.has_key?(:lead_time)
    attrs[:email]     = "#{attrs[:login]}@example.com"  unless attrs.has_key?(:email)

    klass = attrs.delete(:class) || User

    if attrs.has_key?(:password)
      attrs[:password_confirmation] = attrs[:password] unless attrs.has_key?(:password_confirmation)
      klass = User::ForAuthentication
    else
      attrs[:crypted_password] = 'dummy'
      attrs[:password_salt] = 'dummy'
    end

    klass.create!(attrs)
  end

  def create_event(attrs={})
    attrs = {:description => attrs} if attrs.is_a?(String)

    attrs[:description] = 'Recurring Event'     unless attrs.has_key?(:description)
    attrs[:class]       = Event                 unless attrs.has_key?(:class)
    attrs[:user]        = create_user('event')  unless attrs.has_key?(:user)
    attrs[:event_date]  = 10.days.from_now      unless attrs.has_key?(:event_date)
    attrs[:recur]       = true                  unless attrs.has_key?(:recur)

    attrs.delete(:class).create!(attrs)
  end

  def create_occasion(attrs={})
    attrs = {:description => attrs} if attrs.is_a?(String)

    attrs[:description] = 'Recurring Occasion'  unless attrs.has_key?(:description)
    attrs[:class]       = Occasion

    create_event(attrs)
  end

  def create_reminder(attrs={})
    attrs = {:description => attrs} if attrs.is_a?(String)

    attrs[:description] = 'Recurring reminder' unless attrs.has_key?(:description)
    attrs[:class]       = Reminder

    create_event(attrs)
  end

  def create_gift(attrs={})
    attrs = {:description=>attrs} if attrs.is_a?(String)

    attrs[:user]        = create_user('gift') unless attrs.has_key?(:user)
    attrs[:description] = 'gift'              unless attrs.has_key?(:description)
    attrs[:url]         = 'url'               unless attrs.has_key?(:url)
    attrs[:price]       = 1.00                unless attrs.has_key?(:price)

    # Issue 28
    klass = attrs.delete(:class) || Gift
    klass.create!(attrs)
  end

  def login_as(user)
    user = {:login => user} if user.is_a?(String)

    if user.is_a?(Hash)
      user =  User::ForAuthentication.where(user).first ||
              create_user(user.merge(:password => 'my password', :password_confirmation => 'my password'))
    end

    user = user.becomes(User::ForAuthentication)

    UserSession.create(user)
  end

  def logout
    UserSession.find&.destroy
  end

  def user(params={})
    @user ||= create_user({:login => 'test_user', :password => 'my password'}.merge(params))
  end

  def admin
    @admin ||= create_user(:login => 'test_admin', :password => 'my password', :role => 'admin')
  end

  def escape(string)
    ERB::Util.h(string)
  end

end

class Object
  def tap_pp(*args)
    tap {|ii| pp *args, ii}
  end
end

class ActionController::TestCase
  include Authlogic::TestCase
  setup :activate_authlogic
end
