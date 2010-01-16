module OpenIdAuthentication
  module Mongo
    class Association
      include MongoMapper::Document
      set_collection_name :open_id_authentication_associations
      
      key :issued,      Integer
      key :lifetime,    Integer
      key :handle,      String
      key :assoc_type,  String
      key :server_url,  String
      key :secret,      Binary

      def from_record
        OpenID::Association.new(handle, secret.to_s, issued, lifetime, assoc_type)
      end
    end
  end
end
