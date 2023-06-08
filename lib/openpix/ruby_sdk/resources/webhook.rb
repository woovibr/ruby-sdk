# frozen_string_literal: true

require 'openpix/ruby_sdk/resources/resource'

module Openpix
  module RubySdk
    module Resources
      # Make API operations on Webhook resource
      class Webhook < Resource
        ATTRS = %w[
          name
          event
          url
          authorization
          is_active
        ].freeze

        attr_accessor(*ATTRS)

        # @param params [Hash{String => String, Number, Hash{String, Number}, Array<Hash{String, String}>}] the attributes for creating a Charge
        # @param rest [Hash] more attributes to be merged at the body, use this only for unsupported fields
        def init_body(params: {}, rest: {})
          super(base_attrs: ATTRS, params: params, rest: rest)
        end

        def create_attributes
          ATTRS
        end

        def to_url
          'webhook'
        end

        def to_body
          body = super

          { webhook: body }
        end

        # rubocop:disable Lint/UnusedMethodArgument
        def find(id:, extra_headers: {})
          raise(
            ActionNotImplementedError,
            'webhook does not implement GET show action'
          )
        end

        def find!(id:, extra_headers: {})
          raise(
            ActionNotImplementedError,
            'webhook does not implement GET show action'
          )
        end
        # rubocop:enable Lint/UnusedMethodArgument
      end
    end
  end
end
