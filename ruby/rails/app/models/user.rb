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
#  lead_time         :integer          default(10)
#  lead_frequency    :integer          default(10)
#  ui_version        :integer
#

class User < ApplicationRecord

  inheritance_column = :_type_disabled

  has_many :gifts,                                          :class_name => 'Gift::ForGiving', :dependent => :destroy
  has_many :visible_gifts, -> { where(:hidden => false) },  :class_name => 'Gift::ForGiving'  # Issue 85
  has_many :events,        -> { order 'event_date' },       :dependent => :destroy
  has_many :reminders,     -> { order 'event_date' },       :class_name => 'Reminder'
  has_many :occasions,     -> { order 'event_date' },       :class_name => 'Occasion'

  has_and_belongs_to_many :givings,
    :class_name               => 'Gift::ForGiving',
    :join_table               => 'givings',
    :association_foreign_key  => 'gift_id',
    :autosave                 => true,
    :uniq                     => true

  has_and_belongs_to_many :friends,
    :class_name               => 'User',
    :join_table               => 'friends',
    :association_foreign_key  => 'friend_id',
    :autosave                 => true,
    :uniq                     => true

  validates_format_of :login, :with => /\A[^@]+\z/,
                              :message => 'cannot be an email'

  before_destroy :remove_from_friends

  def display_name
    login
  end

  def admin?
    role =~ /admin/
  end

  def give(gift)
    givings << gift.becomes(Gift::ForGiving)
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

  def self.roles
    %w[admin user]
  end

  def self.model_name
    ActiveModel::Name.new(User)
  end

private

  def remove_from_friends
    Friendship.where(:friend_id=>id).delete_all
  end

end
