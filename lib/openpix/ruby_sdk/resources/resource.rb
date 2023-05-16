# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'

module Openpix
  module RubySdk
    module Resources
      class NotImplementedError < StandardError
        def initialize(msg: nil, method: 'nil')
          super(msg) if msg.present?

          super("#{method} not implemented")
        end
      end

      class Resource
        def initialize(base_attrs = [], params = {}, rest = {})
          base_attrs.each { |attr| instance_variable_set("@#{attr}", params[attr]) }
          @rest = rest
        end

        def to_url
          raise NotImplementedError.new(method: __method__)
        end

        def create_attributes
          raise NotImplementedError.new(method: __method__)
        end

        def validation
          raise NotImplementedError.new(method: __method__)
        end

        def to_body
          body = {}

          attributes.each do |attr|
            body[attr.camelize(:lower).gsub('Id', 'ID')] = send(attr)
          end

          body.merge(@rest)
        end
      end
    end
  end
end
