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
