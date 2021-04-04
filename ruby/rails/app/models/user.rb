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

  inheritance_column = :_type_disabled

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

    gifts.map(&:updated_at).compact.max
  end

  def self.find_by_login_or_email(value)
    where(['login = :value OR email = :value', {:value => value}]).first
  end

  def ==(other)
    other.is_a?(User) && !id.nil? && other.id == id
  end

private

  def remove_from_friends
    Friendship.where(:friend_id=>id).delete_all
  end

end
