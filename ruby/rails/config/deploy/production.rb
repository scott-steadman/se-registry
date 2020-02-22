require 'capistrano/deploy_into_docker'

server docker: {container: 'gifts'}, user: 'nobody', roles: %w[app]

set :default_env,     {
                        path:            "/opt/rh/rh-ruby22/root/usr/bin:$PATH",
                        ld_library_path: "/opt/rh/rh-nodejs8/root/usr/lib64:/opt/rh/rh-ruby22/root/usr/lib64",
                        rails_env:       "production",
                      }
set :deploy_to,       '/app/gifts'
set :migration_role,  :app
set :rails_env,       'production'
set :sshkit_backend,  SSHKit::Backend::Docker

namespace :deploy do

  before :restart, :'assets:precompile'

end
