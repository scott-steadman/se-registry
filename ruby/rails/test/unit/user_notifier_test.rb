require File.dirname(__FILE__) + '/../test_helper'

class UserNotifierTest < ActionMailer::TestCase

  def test_send_reminders
    u1 = create_user('user1')
    r1 = u1.reminders.create(:description=>'Reminder 1', :event_date=>Date.tomorrow)
    r2 = u1.reminders.create(:description=>'Reminder 2', :event_date=>Date.tomorrow)

    u2 = create_user('user2')
    r3 = u2.reminders.create(:event_date => Date.tomorrow, :description => 'Tomorrow')

    count = 0
    UserNotifier.send_reminders do |user|
      assert_not_nil user
      count += 1
    end
    assert_equal 2, count

    mails = ActionMailer::Base.deliveries
    assert 2, mails.size
    check_reminder_email(mails[0], [r1, r2])
    check_reminder_email(mails[1], [r3])
  end

  def test_send_occasions
    u1 = create_user('user1')
    r1 = u1.occasions.create(:description=>'Occasion 1', :event_date=>Date.tomorrow)
    r2 = u1.occasions.create(:description=>'Occasion 2', :event_date=>Date.tomorrow)

    u2 = create_user('user2')
    u2.friends << u1
    u2.save!

    count = 0
    UserNotifier.send_occasions do |user|
      assert_not_nil user
      count += 1
    end
    assert_equal 1, count

    mails = ActionMailer::Base.deliveries
    assert 1, mails.size
    check_occasion_email(mails[0], [r1, r2])
  end

  # Ticket #8
  def test_lead_frequency
    user = create_user(:login=>'scott', :lead_time=>10, :lead_frequency=>1)
    user.reminders.create(:description=>'test reminder', :event_date=>Date.tomorrow)

    UserNotifier.send_reminders do |uu|
      assert_equal user, uu
    end

    mails = ActionMailer::Base.deliveries
    assert_equal 1, mails.size

    mail_text = mails[0].to_s
    assert_match Time.now.tomorrow.to_formatted_s(:event), mail_text
  end

  private

    def check_reminder_email(mail, events)
      subject = 'The E-Registry: ' + (events.size > 1 ? 'Reminders' : 'Reminder')
      check_email(mail, subject, events)
    end

    def check_occasion_email(mail, events)
      subject = 'The E-Registry: Occasions'
      check_email(mail, subject, events)
    end

    def check_email(mail, subject, events)
      assert_equal subject, mail.subject
      events.each do |event|
        assert_match event.description, mail.body
        assert_match event.event_date.to_formatted_s(:events), mail.body
        assert_equal events.size, mail.body.scan(/\d{4}-\d{2}-\d{2}/).size
      end
    end

end
