# frozen_string_literal: true

module Openpix
  module RubySdk
    class HttpClient
      BASE_URL = 'https://api.woovi.com/api'
      API_VERSION = '/v1'

      def initialize
        @http_client = HTTPX.with(
          origin: BASE_URL,
          base_path: API_VERSION
        ).plugin(:authentication).authentication(ENV['OPENPIX_APP_ID'])
      end

      def post(_resource, _request_options)
        @http_client
      end
    end
  end
end
