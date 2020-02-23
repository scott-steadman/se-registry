require 'capistrano/deploy_into_docker'

server docker: {container: 'gifts-ruby-2.5'}, user: '99:1000', roles: %w[app db web]

set :default_env,     {
                        rails_env: "production",
                      }
set :deploy_to,       '/app/gifts'
set :rails_env,       'production'
set :sshkit_backend,  SSHKit::Backend::Docker

append :linked_dirs,  'log', 'tmp'
