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

  def appear
Rails.logger.info{"user-#{id} appeared"}
  end

  def disappear
Rails.logger.info{"user-#{id} disappeared"}
  end

end # class User::ForPresence
