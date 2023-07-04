# frozen_string_literal: true

module Openpix
  module RubySdk
    # An Object representing the response from a call to Woovi API
    class ApiResponse
      attr_reader :success, :body, :status

      def initialize(status:, body:, single_resource: nil, collection_resource: nil)
        @success = status == 200
        @status = status
        @body = body
        @single_resource = single_resource
        @collection_resource = collection_resource
      end

      def success?
        success
      end

      def resource_response
        return @body[@single_resource] if @single_resource

        @body[@collection_resource]
      end

      def error_response
        return @body['error'] if @body['error']
        return @body['errors'].first['message'] if @body['errors'] && !@body['errors'].empty?

        ''
      end

      def pagination_meta
        return @body['pageInfo'] if @body['pageInfo']

        {}
      end
    end
  end
end
