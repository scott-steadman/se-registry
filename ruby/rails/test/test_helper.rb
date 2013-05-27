ENV["RAILS_ENV"] = "test"
require File.expand_path("#{File.dirname(__FILE__)}/../config/environment")
require 'test_help'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Add more helper methods to be used by all tests here...


  def create_user(attrs={})
    attrs = {:login=>attrs} if attrs.is_a?(String)
    User.create({
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
    attrs.delete(:class).create({
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
    Gift.create({
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

end

class Object
  def tap_pp
    tap {|ii| pp ii.class, ii}
  end
end

class ActionController::TestCase
  setup :activate_authlogic
end
