# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_blabbr_session',
  :secret => '575b7031b83753a7fc9621ffc51d1f086f34f865324d78052ed53463aa7efa0f19ead52bbc1832a53001ba7840d4b8976260d21d44c322e14d6cbe0d0130f70e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
