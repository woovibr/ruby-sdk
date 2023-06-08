# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'

module Openpix
  module RubySdk
    # Helper class to format body params before request
    class ApiBodyFormatter
      class << self
        def format_entity_param(entity)
          formatted_entity = {}

          entity.each do |attr, value|
            formatted_entity[transform_id_pattern(attr)] = value
          end

          remove_empty_values(formatted_entity)
        end

        def remove_empty_values(entity)
          entity.compact.reject do |_key, value|
            value.empty? if value.respond_to?(:empty?)
          end
        end

        def transform_id_pattern(attr_key)
          attr_key.camelize(:lower).gsub('Id', 'ID')
        end
      end
    end
  end
end
