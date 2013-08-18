ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def create_user(attrs={})
    attrs = {:login=>attrs} if attrs.is_a?(String)
    User.create!({
      :login                 => 'quire',
      :password              => 'quire',
      :password_confirmation => 'quire',
      :lead_time             => 10
    }.merge(attrs)) do |user|
      user.email ||= "#{user.login}@example.com" unless attrs.has_key?(:email)
      user.role = attrs[:role] if attrs.has_key?(:role)
    end
  end

  def create_event(attrs={})
    attrs = {:description=>attrs} if attrs.is_a?(String)
    attrs[:description] ||=  'Recurring Event'
    attrs[:class] ||= Event
    attrs.delete(:class).create!({
      :event_date  => 10.days.from_now,
      :recur       => true
    }.merge(attrs)) do |event|
      event.user = (attrs[:user] || create_user('event'))
    end
  end

  def create_occasion(attrs={})
    attrs = {:description=>attrs} if attrs.is_a?(String)
    attrs[:description] ||=  'Recurring Occasion'
    attrs[:class] = Occasion
    create_event(attrs)
  end

  def create_reminder(attrs={})
    attrs = {:description=>attrs} if attrs.is_a?(String)
    attrs[:description] ||=  'Recurring reminder'
    attrs[:class] = Reminder
    create_event(attrs)
  end


  def create_gift(attrs={})
    attrs = {:description=>attrs} if attrs.is_a?(String)
    Gift.create!({
      :description => 'gift',
      :url         => 'url',
      :price       => 1.00
    }.merge(attrs)) do |gift|
      gift.user = (attrs[:user] || create_user('gift'))
    end
  end

  def login_as(user)
    user = user.login if user.respond_to?(:login)
    UserSession.create(User.first(:conditions=>{:login=>user}) || create_user(user))
  end

  def logout
    UserSession.find.destroy
  end

  def escape(string)
    ERB::Util.h(string)
  end

end

class Object
  def tap_pp
    tap {|ii| pp ii.class, ii}
  end
end

class ActionController::TestCase
  setup :activate_authlogic
end
