role :app, "gifts.stdmn.com"
role :web, "gifts.stdmn.com"
role :db,  "gifts.stdmn.com", :primary => true

set :ssh_options, {
  user: 'scott.steadman',
}
