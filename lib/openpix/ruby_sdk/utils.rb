# frozen_string_literal: true

require 'base64'
require 'openssl'

module Openpix
  module RubySdk
    # Entrypoint class to access utility methods to facilitate interaction with our APIs
    class Utils
      BASE64_PUB_KEY = 'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlHZk1BMEdDU3FHU0liM0RRRUJBUVVBQTRHTkFEQ0JpUUtCZ1FDLytOdElranpldnZxRCtJM01NdjNiTFhEdApwdnhCalk0QnNSclNkY2EzcnRBd01jUllZdnhTbmQ3amFnVkxwY3RNaU94UU84aWVVQ0tMU1dIcHNNQWpPL3paCldNS2Jxb0c4TU5waS91M2ZwNnp6MG1jSENPU3FZc1BVVUcxOWJ1VzhiaXM1WloySVpnQk9iV1NwVHZKMGNuajYKSEtCQUE4MkpsbitsR3dTMU13SURBUUFCCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo='
      PUB_KEY_INSTANCE = OpenSSL::PKey::RSA.new(Base64.decode64(BASE64_PUB_KEY))

      class << self
        def verify_signature(base64_signature, payload)
          PUB_KEY_INSTANCE.verify(
            OpenSSL::Digest.new('SHA256'),
            Base64.decode64(base64_signature),
            payload
          )
        end
      end
    end
  end
end
