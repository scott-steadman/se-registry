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

  desc 'migrate data'
  task :copy_db => :environment do
    ActiveRecord::Base.partial_writes = false

    {
      User        => {},
      Event       => {},
      Gift        => {},
      Friendship  => {:unique_by => [:user_id, :friend_id]},
      Tag         => {},
      Tagging     => {},
    }.each do |klass, opts|
      models       = nil
      column_names = nil

      with_dest do
        column_names = klass.column_names.tap{|ii| pp [:cn, klass.name, ii]}
      end

      with_source do
        models = klass.all.select(column_names).to_a
        puts "#{models.count} #{klass.name}s to migrate"
      end

      with_dest do
        models.each do |model|
          attrs = model.attributes.except('tag_list')
          print klass.upsert(attrs, opts) ? '+' : '-'
        end
      end

      puts "\nDone."
    end
  end

private

  def with_source(&block)
    ActiveRecord::Base.connected_to(:database => {:url => ENV['SOURCE_DB_URL']}) do
      yield
    end
  end

  def with_dest(&block)
    ActiveRecord::Base.connected_to(:database => {:url => ENV['DEST_DB_URL']}) do
      yield
    end
  end

end
