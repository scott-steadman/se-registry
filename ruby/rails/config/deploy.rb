abort "needs capistrano 2" unless respond_to?(:namespace)

set :application, 'gifts.stdmn.com'
#set :application, 'foo'
set :repository,  'git://github.com/ss/se-registry.git'
set :run_method, :run

set :scm, :git
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :scm_verbose, true

role :app, "gifts.stdmn.com"
role :web, "gifts.stdmn.com"
role :db,  "gifts.stdmn.com", :primary => true

namespace :deploy do

  desc "Cleanup after successful deployment"
  task :after_default do
    cleanup
  end

  task :before_finalize_update, :roles=>:app do
    set :latest_release, "#{current_release}/ruby/rails"
  end

  desc 'Restart the app server'
  task :restart, :roles=>:app do
    sudo "chgrp -R apache #{current_release}", :pty=>true
    run "touch #{current_path}/tmp/restart.txt"
  end
end
