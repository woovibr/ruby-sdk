# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'

require 'openpix/ruby_sdk/http_client'
require 'openpix/ruby_sdk/resources'

module Openpix
  module RubySdk
    # Entrypoint class, expect to access resources and other classes just from this class
    class Client
      RESOURCES = %w[
        Charge
        Customer
        Payment
      ].freeze

      def initialize(auth_token)
        @auth_token = auth_token

        init_http_client
      end

      RESOURCES.each do |resource|
        pluralized_resource_name = resource.downcase.pluralize
        define_method pluralized_resource_name do
          return instance_variable_get("@#{pluralized_resource_name}") if instance_variable_get("@#{pluralized_resource_name}")

          instance_variable_set(
            "@#{pluralized_resource_name}",
            "Openpix::RubySdk::Resources::#{resource}".constantize.new(@http_client)
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
