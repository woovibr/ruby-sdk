# frozen_string_literal: true

require 'openpix/ruby_sdk/http_client'
require 'active_support'
require 'active_support/core_ext/string/inflections'

module Openpix
  module RubySdk
    # Entrypoint class, expect to access resources and other classes just from this class
    class Client
      RESOURCES = %w[
        Charge
        Customer
      ].freeze

      def initialize(auth_token)
        @auth_token = auth_token

        init_http_client
      end

      RESOURCES.each do |resource|
        pluralized_resource_name = resource.downcase.pluralize
        define_method pluralized_resource_name, do
          instance_variable_set(
            "@#{pluralized_resource_name}",
            "Openpix::RubySdk::Resources::#{resource}}".constantize.new(http_client)
          )
        end
      end

      private

      def init_http_client
        @http_client = Openpix::RubySdk::HttpClient.instance

        @http_client.initialize_http_client(@auth_token)
      end
    end
  end
end
