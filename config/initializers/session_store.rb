# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Blabber_session',
  :secret      => '1f22bddf486f545ef5917469a5a6a4b5acd2427d079aa453f5f44de1aa2eedc1d2bce4009685255aed241ee59d2973c46dc9ac6a0ca6c514ae7e3bc3374548bb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
