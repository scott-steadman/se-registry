# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  login             :string           not null
#  role              :string           default("user"), not null
#  notes             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  email             :string
#  crypted_password  :string           not null
#  password_salt     :string           not null
#  persistence_token :string
#  current_login_at  :datetime
#  last_login_at     :datetime
#  lead_time         :integer          default("10"), not null
#  lead_frequency    :integer          default("10"), not null
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

  has_many :gifts,                                          :dependent => :destroy
  has_many :visible_gifts, -> { where(:hidden => false) },  :class_name => 'Gift'  # Issue 85
  has_many :events,        -> { order 'event_date' },       :dependent => :destroy
  has_many :reminders,     -> { order 'event_date' },       :class_name => 'Reminder'
  has_many :occasions,     -> { order 'event_date' },       :class_name => 'Occasion'

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

  validates_format_of :login, :with => /\A[^@]+\z/,
                              :message => 'cannot be an email'

  # Validate email, login, and password as you see fit.
  #
  # Authlogic < 5 added these validation for you, making them a little awkward
  # to change. In 4.4.0, those automatic validations were deprecated. See
  # https://github.com/binarylogic/authlogic/blob/master/doc/use_normal_rails_validation.md
  validates :email,
    format: {
      with: /@/,
      message: "should look like an email address."
    },
    length: { within: 3..100 },
    uniqueness: {
      case_sensitive: false,
      if: :will_save_change_to_email?
    }

  validates :login,
    format: {
      with: /\A[a-z0-9_]+\z/,
      message: "should use only letters and numbers."
    },
    length: { within: 3..40 },
    uniqueness: {
      case_sensitive: false,
      if: :will_save_change_to_login?
    }

  validates :password,
    confirmation: { if: :require_password? },
    length: {
      minimum: 8,
      if: :require_password?
    }
  validates :password_confirmation,
    length: {
      minimum: 8,
      if: :require_password?
  }

  before_destroy :remove_from_friends

  def display_name
    login
  end

  def admin?
    role =~ /admin/
  end

  def self.find_needs_reminding(date=Time.now)
    includes(:reminders)
    .references(:reminders)
    .where(['(events.event_date - ?) <= users.lead_time', date])
    .where(['((events.event_date - ?) % users.lead_frequency) = 0', date])
  end

  def self.find_has_occasions(date=Time.now)
    includes(:friends => :occasions)
    .references(:friends => :occasions)
    .where(['(events.event_date - ?) <= users.lead_time', date])
    .where(['((events.event_date - ?) % users.lead_frequency) = 0', date])
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

  def last_gift_updated_at
    return nil if gifts.none?

    gifts.order(:updated_at).last.updated_at
  end

  def self.find_by_login_or_email(value)
    where(['login = :value OR email = :value', {:value => value}]).first
  end

private

  def remove_from_friends
    Friendship.where(:friend_id=>id).delete_all
  end

end
