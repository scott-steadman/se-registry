# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_registry_session',
  :secret      => 'fbf90e523ea37af7ef8e2919c672f0fe11309d7d43d43ce21ec2a17f6f65ab0c5679dab58a6b5d49b6b2e6dd3934c32d6378e5ffc7184eea7460244d24ae7fff'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
