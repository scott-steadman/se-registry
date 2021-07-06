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

# Issue 31
class User::ForPresence < User

  has_and_belongs_to_many :friends_to_notify,
    :class_name               => 'User::ForPresence',
    :foreign_key              => 'friend_id',
    :join_table               => 'friends',
    :association_foreign_key  => 'user_id',
    :autosave                 => true,
    :uniq                     => true

  # called from Presence::AppearJob
  def appear
    friends_to_notify.each do |friend|
      PresenceChannel.broadcast_to(friend, :event => 'appear', :friend_id => id)
    end

  end

  def disappear
Rails.logger.info{"user-#{id} disappeared"}
  end

end # class User::ForPresence
