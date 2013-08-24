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

class User < ActiveRecord::Base

  class OldCrypto
    def self.encrypt(password, salt=nil)
      require 'digest/sha1'
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    def self.matches?(crypted_password, password, salt=nil)
      encrypt(password, salt) == crypted_password
    end
  end

  acts_as_authentic do |config|
    config.transition_from_crypto_providers = OldCrypto
  end

  attr_accessible :login, :password, :password_confirmation, :email,
                  :postal_code, :notes, :lead_time, :lead_frequency, :as => [:admin, :tester, :user]

  attr_accessible :role, :as => [:admin, :tester]


  has_many :gifts, :dependent => :destroy
  has_many :events, :dependent => :destroy, :order => 'event_date'
  has_many :reminders, :class_name => 'Reminder', :order => 'event_date'
  has_many :occasions, :class_name => 'Occasion', :order => 'event_date'

  has_and_belongs_to_many :givings,
    :class_name => 'Gift',
    :join_table => 'givings',
    :association_foreign_key => 'gift_id',
    :autosave => true,
    :uniq => true

  has_and_belongs_to_many :friends,
    :class_name => 'User',
    :join_table => 'friends',
    :association_foreign_key => 'friend_id',
    :autosave => true,
    :uniq => true

  validates_presence_of     :login, :email
  validates_length_of       :login, :within => 3..40
  validates_length_of       :email, :within => 3..100
  validates_format_of       :login, :with => /\A[^@]+\z/,
                                    :message => 'cannot be an email'
  validates_uniqueness_of   :login, :case_sensitive => false

  before_destroy :remove_from_friends

  def display_name
    login
  end

  def admin?
    role =~ /admin/
  end

  def self.find_needs_reminding(date=Time.now)
    all(
      :include => :reminders,
      :conditions => ['datediff(events.event_date, ?) <= users.lead_time and datediff(events.event_date, ?) mod users.lead_frequency = 0', date, date]
    )
  end

  def self.find_has_occasions(date=Time.now)
    all(
      :include => {:friends => :occasions},
      :conditions => ['datediff(events.event_date, ?) <= users.lead_time and datediff(events.event_date, ?) mod users.lead_frequency = 0', date, date]
    )
  end

  def give(gift)
    givings << gift
  end

  def befriend(friend)
    friends << friend
  end

  def last_login_at
    super || created_at
  end

private

  def remove_from_friends
    Friendship.delete_all(:friend_id=>id)
  end

end
