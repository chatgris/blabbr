module OpenIdAuthentication
  module Mongo
    class Nonce
      include MongoMapper::Document
      set_collection_name :open_id_authentication_nonces
      
      key :timestamp,   Integer
      key :server_url,  String
      key :salt,        String
    end
  end
end
