# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'openpix/ruby_sdk/http_client'
require 'openpix/ruby_sdk/api_response'

module Openpix
  module RubySdk
    module Resources
      class NotImplementedError < StandardError
        def initialize(msg: nil, method: 'nil')
          super(msg) if msg.present?

          super("#{method} not implemented")
        end
      end

      # Error raised when there is a status != from 200 from the API response
      # This is just raised in methods that calls the bang (with exclamation mark "!") version
      class RequestError < StandardError
      end

      class Resource
        def initialize(http_client)
          @http_client = http_client
        end

        def init_body(base_attrs: [], params: {}, rest: {})
          base_attrs.each { |attr| instance_variable_set("@#{attr}", params[attr]) }
          @rest = rest
        end

        def to_url
          raise NotImplementedError.new(method: __method__)
        end

        def create_attributes
          raise NotImplementedError.new(method: __method__)
        end

        def to_body
          body = {}

          create_attributes.each do |attr|
            body[attr.camelize(:lower).gsub('Id', 'ID')] = send(attr)
          end

          body.merge(@rest)
        end

        def save(extra_headers: {}, return_existing: false)
          response = post_request(extra_headers, return_existing)

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_url],
            error_response: response.body['error']
          )
        end

        def save!(extra_headers: {}, return_existing: false)
          response = post_request(extra_headers, return_existing)

          if response.status != 200
            raise(
              RequestError,
              "Error while saving, API response: #{response.body['error']}, status: #{response.status}"
            )
          end

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_url]
          )
        end

        private

        def post_request(extra_headers, return_existing)
          @http_client.post(
            to_url,
            body: to_body,
            headers: extra_headers,
            params: { return_existing: return_existing }
          )
        end
      end
    end
  end
end
