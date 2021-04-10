class UserNotifier < ActionMailer::Base

  default :from => EMAIL_SENDER

  def reminders(user)
    @user = user
    mail(:to => user.email, :subject => "The E-Registry: #{'Reminder'.pluralize(user.reminders.size)}")
  end

  def occasions(user)
    @user = user
    mail(:to => user.email, :subject => "The E-Registry: Occasions")
  end

  def self.send_reminders(date=Time.now)
    User::ForNotifying.find_needs_reminding(date).each do |user|
      reminders(user).deliver_now
      yield user if block_given?
    end
  end

  def self.send_occasions(date=Time.now)
    User::ForNotifying.find_has_occasions(date).each do |user|
      occasions(user).deliver_now
      yield user if block_given?
    end
  end

  def self.send_test_emails(to)
    user = User.find_by_email(to)
    raise ArgumentError, "No user with Email: #{to}" unless user

    puts "Sending emails to: #{user.login}..." unless Rails.env.test?
    reminders(user).deliver_now
    occasions(user).deliver_now
  end

end
