namespace :test do

  desc 'Generate coverage report'
  task :coverage => [:environment] do
    ENV['COVERAGE'] = 'true'
    system('rake test')
  end

end
