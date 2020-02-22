require 'capistrano/deploy_into_docker'

server docker: {container: 'gifts-ruby-2.5'}, user: '99', roles: %w[app]

set :default_env,     {
                        rails_env: "production",
                      }
set :deploy_to,       '/app/gifts'
set :migration_role,  :app
set :rails_env,       'production'
set :sshkit_backend,  SSHKit::Backend::Docker

namespace :deploy do

  after :migrate, :'assets:precompile'

end
