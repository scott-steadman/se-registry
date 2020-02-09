role :app, "gifts.stdmn.com"
role :web, "gifts.stdmn.com"
role :db,  "gifts.stdmn.com", :primary => true

set :pty, true
set :ssh_options, {
  user: 'scott.steadman',
}

namespace :deploy do

  before :restart, :ignored do
    on roles(:web) do
      sudo "chgrp -R apache #{fetch(:release_path)}"
    end
  end

  after :restart, :'passenger:restart'
end
