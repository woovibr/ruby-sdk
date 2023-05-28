# frozen_string_literal: true

module Openpix
  module RubySdk
    # An Object representing the response from a call to Woovi API
    class ApiResponse
      attr_reader :success, :resource_response, :pagination_meta, :error_response, :status

      def initialize(status:, resource_response: nil, error_response: nil, pagination_meta: {})
        @success = status == 200
        @status = status
        @resource_response = resource_response
        @pagination_meta = pagination_meta
        @error_response = error_response
      end

      def success?
        success
      end
    end
  end
end
