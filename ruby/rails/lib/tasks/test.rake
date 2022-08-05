namespace :test do

  desc 'Generate coverage report'
  task :coverage => [:environment] do
    ENV['COVERAGE'] = 'true'
    system('rake test')
  end


  desc 'Send test emails (TO=<email>)'
  task :emails => [:environment] do
    raise '**** ERROR: Email required (TO=<email>)' unless ENV['TO']
    UserNotifier.send_test_emails(ENV['TO'])
  end

end
