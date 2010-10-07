# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rottenpotatoes_session',
  :secret      => '1bcfa658b7e4562189655f3d77a1fb4b09a066dd9135c3685f57efdf22a7e24140fb0b70040bb7a9ad22b81037a0f04cb64d9e0f1880da00292c8a558565ec23'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
