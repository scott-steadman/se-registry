# == Schema Information
# Schema version: 10
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  role                      :string(32)      default("user"), not null
#  postal_code               :string(16)
#  lead_time                 :integer(4)
#  lead_frequency            :integer(4)      default(1), not null
#  notes                     :string(255)
#

require 'digest/sha1'
class User < ActiveRecord::Base

  # only allow these fields to be assigned using update_attributes
  attr_accessible :login, :password, :password_confirmation, :email,
                  :postal_code, :notes, :lead_time, :lead_frequency

  # Virtual attribute for the unencrypted password
  attr_accessor :password

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
  validates_presence_of     :password,                    :if => :password_required?
  validates_presence_of     :password_confirmation,       :if => :password_required?
  validates_length_of       :password,  :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                    :if => :password_required?
  validates_length_of       :login,     :within => 3..40
  validates_length_of       :email,     :within => 3..100
  validates_uniqueness_of   :login,     :case_sensitive => false

  before_save :encrypt_password
  before_destroy :remove_from_friends

  def display_name
    login
  end

  def admin?
    role =~ /admin/
  end

  def reset_password
    self.password = self.password_confirmation = 'changeme'
    UserNotifier.deliver_reset_password(self)
    save!
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def self.find_needs_reminding(date=Time.now)
    find(:all,
      :include => :reminders,
      :conditions => ['datediff(events.event_date, ?) <= users.lead_time and datediff(events.event_date, ?) mod users.lead_frequency = 0', date, date]
    )
  end

  def self.find_has_occasions(date=Time.now)
    find(:all,
      :include => {:friends => :occasions},
      :conditions => ['datediff(events.event_date, ?) <= users.lead_time and datediff(events.event_date, ?) mod users.lead_frequency = 0', date, date]
    )
  end


  protected

    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end


  private

    def remove_from_friends
      Friendship.delete_all(:friend_id=>id)
    end

end
