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
class User::ForNotifying < User

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

end # class User::ForNotifying
