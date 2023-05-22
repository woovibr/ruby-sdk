# frozen_string_literal: true

require 'openpix/ruby_sdk/resources/resource'
require 'openpix/ruby_sdk/resources/customer'

module Openpix
  module RubySdk
    module Resources
      # Make API operations on Charge resource
      class Charge < Resource
        ATTRS = %w[
          correlation_id
          value
          type
          comment
          identifier
          expires_in
          customer
          days_for_due_date
          days_after_due_date
          interests
          fines
          additional_info
        ].freeze

        attr_accessor(*ATTRS)

        # @param params [Hash{String => String, Number, Hash{String, Number}, Array<Hash{String, String}>}] the attributes for creating a Charge
        # @param rest [Hash] more attributes to be merged at the body, use this only for unsupported fields
        def init_body(params: {}, rest: {})
          super(base_attrs: ATTRS, params: params, rest: rest)
        end

        # attributes used on POST create method
        def create_attributes
          ATTRS
        end

        # URL for this resource
        def to_url
          'charge'
        end

        # Converts its attributes into a hash
        def to_body
          body = super

          customer_parsed = {}
          body['customer']&.each do |attr, value|
            customer_parsed[attr.camelize(:lower).gsub('Id', 'ID')] = value
          end

          customer_address_parsed = {}
          body.dig('customer', 'address')&.each do |attr, value|
            customer_address_parsed[attr.camelize(:lower).gsub('Id', 'ID')] = value
          end

          body['customer'] = customer_parsed
          body['customer'] = body['customer'].merge({ 'address' => customer_address_parsed })

          body
        end

        # add a new additional_info
        # @param key [String] the key
        # @param value [String] the value
        def add_additional_info(key, value)
          @additional_info = [] if @additional_info.nil?

          @additional_info << { 'key' => key, 'value' => value }
        end

        # set interests configuration for creating this resource
        # @param value [Number] value in basis points of interests to be applied daily after the charge hits the deadline
        def set_interests(value)
          @interests = { 'value' => value }
        end

        # set fines configuration for creating this resource
        # @param value [Number] value in basis points of fines to be applied when the charge hits the deadline
        def set_fines(value)
          @fines = { 'value' => value }
        end
      end
    end
  end
end
