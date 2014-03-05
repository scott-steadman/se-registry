namespace :registry do

  desc 'Send reminder emails'
  task :send_reminders=>:environment do
    puts 'Sending reminders...'
    UserNotifier.send_reminders do |user|
      puts "Sent reminder(s) to: #{user.email}"
    end
  end

  desc 'Send occasion emails'
  task :send_occasions=>:environment do
    puts 'Sending occasions...'
    UserNotifier.send_occasions do |user|
      puts "Sent occasions to: #{user.email}"
    end
  end


  desc 'Update/delete expired events'
  task :update_events=>:environment do
    puts 'Expiring events...'
    Event.expire_events do |event|
      verb = event.deleted? ? 'Expired' : 'Updated'
      puts "#{verb}: #{event.user.login}/#{event.description} => #{event.event_date.to_s}"
    end
  end

end
