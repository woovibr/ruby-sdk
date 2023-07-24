# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'

module Openpix
  module RubySdk
    # Helper class to format body params before request
    class ApiBodyFormatter
      class << self
        def remove_empty_values(entity)
          entity.compact.reject do |_key, value|
            value.empty? if value.respond_to?(:empty?)
          end
        end
      end
    end
  end
end
