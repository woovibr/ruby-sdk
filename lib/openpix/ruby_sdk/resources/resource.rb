# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'

require 'openpix/ruby_sdk/api_response'
require 'openpix/ruby_sdk/api_body_formatter'

module Openpix
  module RubySdk
    module Resources
      # Error returned when the required method is not implemented in the class child class
      class NotImplementedError < StandardError
        def initialize(msg: nil, method: 'nil')
          super(msg) if msg.present?

          super("#{method} not implemented")
        end
      end

      # Error raised when there is a status != from 200 from the API response
      # This is just raised in methods that calls the bang (with exclamation mark "!") version
      class RequestError < StandardError
      end

      # Error raised when client is trying to fetch next/previous page without fetching without pagination first
      class NotFetchedError < StandardError
      end

      # Error raised when client is trying to fetch next/previous page and page does not exists
      class PageNotDefinedError < StandardError
      end

      # Error raised when client is trying to use a Restful action that is not implemented in the current resource
      class ActionNotImplementedError < StandardError
      end

      # Base class for resources from the API
      class Resource
        def initialize(http_client)
          @http_client = http_client
        end

        def init_body(base_attrs: [], params: {}, rest: {})
          params = params.with_indifferent_access
          base_attrs.each { |attr| instance_variable_set("@#{attr}", params[attr]) }
          @rest = rest

          self
        end

        def to_url
          raise NotImplementedError.new(method: __method__)
        end

        def to_single_resource
          to_url
        end

        def create_attributes
          raise NotImplementedError.new(method: __method__)
        end

        def to_body
          body = {}

          create_attributes.each do |attr|
            body[Openpix::RubySdk::ApiBodyFormatter.transform_id_pattern(attr)] = send(attr)
          end

          compacted_body = Openpix::RubySdk::ApiBodyFormatter.remove_empty_values(body)

          return compacted_body unless @rest

          compacted_body.merge(@rest)
        end

        def save(extra_headers: {}, return_existing: false)
          response = post_request(extra_headers, return_existing)

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_single_resource],
            error_response: response.body['error']
          )
        end

        def save!(extra_headers: {}, return_existing: false)
          response = post_request(extra_headers, return_existing)

          if response.status != 200
            raise(
              RequestError,
              "Error while saving, API response: #{response.body['error']}, status: #{response.status}"
            )
          end

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_single_resource]
          )
        end

        def fetch(skip: nil, limit: nil, extra_headers: {})
          set_pagination(skip, limit)

          response = get_request(extra_headers: extra_headers, params: @pagination_params)

          @fetched = response.status == 200

          set_pagination_meta(response.body['pageInfo']) if @fetched

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_url.pluralize],
            pagination_meta: response.body['pageInfo'],
            error_response: response.body['error']
          )
        end

        def fetch!(skip: nil, limit: nil, extra_headers: {})
          set_pagination(skip, limit)

          response = get_request(extra_headers: extra_headers, params: @pagination_params)

          if response.status != 200
            raise(
              RequestError,
              "Error while fetching, API response: #{response.body['error']}, status: #{response.status}"
            )
          end

          @fetched = true

          set_pagination_meta(response.body['pageInfo'])

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            pagination_meta: response.body['pageInfo'],
            resource_response: response.body[to_url.pluralize]
          )
        end

        def fetch_next_page!(extra_headers: {})
          fetch_page!(:next, extra_headers)
        end

        def fetch_previous_page!(extra_headers: {})
          fetch_page!(:previous, extra_headers)
        end

        def find(id:, extra_headers: {})
          response = get_request(url: encoded_url(id), extra_headers: extra_headers)

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_single_resource],
            error_response: response.body['error']
          )
        end

        def find!(id:, extra_headers: {})
          response = get_request(url: encoded_url(id), extra_headers: extra_headers)

          if response.status != 200
            raise(
              RequestError,
              "Error while getting #{to_single_resource} of id = #{id}, API response: #{response.body['error']}, status: #{response.status}"
            )
          end

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            resource_response: response.body[to_single_resource]
          )
        end

        def destroy(id:, extra_headers: {})
          response = delete_request(url: encoded_url(id), extra_headers: extra_headers)

          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            error_response: response.body['error']
          )
        end

        def destroy!(id:, extra_headers: {})
          response = delete_request(url: encoded_url(id), extra_headers: extra_headers)

          if response.status != 200
            raise(
              RequestError,
              "Error while deleting #{to_url} of id = #{id}, API response: #{response.body['error']}, status: #{response.status}"
            )
          end

          Openpix::RubySdk::ApiResponse.new(
            status: response.status
          )
        end

        private

        def post_request(extra_headers, return_existing)
          @http_client.post(
            to_url,
            body: to_body,
            headers: extra_headers,
            params: { return_existing: return_existing }
          )
        end

        def get_request(url: to_url, extra_headers: {}, params: {})
          @http_client.get(
            url,
            headers: extra_headers,
            params: params
          )
        end

        def delete_request(url: to_url, extra_headers: {})
          @http_client.delete(
            url,
            headers: extra_headers
          )
        end

        def set_pagination(skip, limit)
          @pagination_params = { skip: 0, limit: 100 } if @pagination_params.nil?
          @pagination_params[:skip] = 0 if @pagination_params[:skip].nil?
          @pagination_params[:limit] = 100 if @pagination_params[:limit].nil?

          @pagination_params[:skip] = skip if skip

          return unless limit

          @pagination_params[:limit] = limit
        end

        def set_pagination_meta(pagination_meta)
          @pagination_meta = {
            total_count: pagination_meta['totalCount'],
            has_previous_page: pagination_meta['hasPreviousPage'],
            has_next_page: pagination_meta['hasNextPage']
          }
        end

        def calculate_pagination_params(page_orientation)
          if page_orientation == :next
            @pagination_params[:skip] += @pagination_params[:limit]
          elsif page_orientation == :previous
            @pagination_params[:skip] -= @pagination_params[:limit]
          end
        end

        def fetch_page!(page_orientation, extra_headers = {})
          unless @fetched
            raise(
              NotFetchedError,
              "#fetch needs to be called before trying to fetch #{page_orientation} page"
            )
          end

          unless @pagination_meta["has_#{page_orientation}_page".to_sym]
            raise(
              PageNotDefinedError,
              "There is no #{page_orientation} page defined for the skip: #{@pagination_params[:skip]} and "\
              "limit: #{@pagination_params[:limit]} params requested"
            )
          end

          calculate_pagination_params(page_orientation)
          response = get_request(extra_headers: extra_headers, params: @pagination_params)

          if response.status != 200
            raise(
              RequestError,
              "Error while fetching #{page_orientation} page, API response: #{response.body['error']}, status: #{response.status}"
            )
          end

          set_pagination_meta(response.body['pageInfo'])
          Openpix::RubySdk::ApiResponse.new(
            status: response.status,
            pagination_meta: response.body['pageInfo'],
            resource_response: response.body[to_url.pluralize]
          )
        end

        def encoded_url(id)
          "#{to_url}/#{URI.encode_www_form_component(id)}"
        end
      end
    end
  end
end
