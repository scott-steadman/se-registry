class UserNotifier < ActionMailer::Base

  def reminders(user)
    setup_email(user)
    @subject += (user.reminders.size > 1 ? 'Reminders' : 'Reminder')
    @body[:reminders] = user.reminders
  end

  def occasions(user)
    setup_email(user)
    @subject += "Occasions"
    @body[:friends] = user.friends
  end

  def self.send_reminders(date=Time.now)
    User.find_needs_reminding(date).each do |user|
      deliver_reminders(user)
      yield user if block_given?
    end
  end

  def self.send_occasions(date=Time.now)
    User.find_has_occasions(date).each do |user|
      deliver_occasions(user)
      yield user if block_given?
    end
  end

private

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = EMAIL_SENDER
    @subject     = "The E-Registry: "
    @sent_on     = Time.now
    @body[:user] = user
  end

end
