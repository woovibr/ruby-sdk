# frozen_string_literal: true

require 'openpix/ruby_sdk/resources/resource'

module Openpix
  module RubySdk
    module Resources
      class Customer < Resource
        ATTRS = %w[
          name
          email
          phone
          tax_id
          correlation_id
          address
        ].freeze

        attr_accessor(*ATTRS)

        def initialize(params, rest = {})
          super(ATTRS, params, rest)
        end

        def create_attributes
          ATTRS
        end

        def to_url
          '/customer'
        end

        def validation; end
      end
    end
  end
end
