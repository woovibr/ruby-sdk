# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'

RSpec.shared_examples 'fetchable resource' do |params|
  let(:mocked_http_client) { double('http_client') }
  let(:resource) { params[:resource_class].new(mocked_http_client) }
  let(:request_response) do
    Struct.new(:status, :body) do
      def initialize(status:, body: {})
        super(status, body)
      end
    end
  end

  describe '#fetch' do
    it 'fetches resources through http_client get method' do
      expect(mocked_http_client).to receive(:get).with(
        resource.to_url,
        headers: {},
        params: { skip: 0, limit: 100 }
      ).and_return request_response.new(
        status: 200,
        body: {
          'pageInfo' => {
            'totalCount' => 10,
            'hasPreviousPage' => false,
            'hasNextPage' => false
          }
        }.merge(params[:body_response])
      )

      response = resource.fetch

      expect(response.success?).to eq(true)
      expect(response.resource_response).to eq(params[:body_response][resource.to_url.pluralize])
    end

    context 'with error response' do
      it 'returns success false and shows the error message' do
        expect(mocked_http_client).to receive(:get).with(
          resource.to_url,
          headers: {},
          params: { skip: 0, limit: 100 }
        ).and_return request_response.new(
          status: 400,
          body: params[:error_response]
        )

        response = resource.fetch

        expect(response.success?).to eq(false)
        expect(response.error_response).to eq(params[:error_response]['error'])
      end
    end
  end

  describe '#fetch!' do
    it 'fetches resources through http_client get method' do
      expect(mocked_http_client).to receive(:get).with(
        resource.to_url,
        headers: {},
        params: { skip: 0, limit: 100 }
      ).and_return request_response.new(
        status: 200,
        body: {
          'pageInfo' => {
            'totalCount' => 10,
            'hasPreviousPage' => false,
            'hasNextPage' => false
          }
        }.merge(params[:body_response])
      )

      response = resource.fetch!

      expect(response.success?).to eq(true)
      expect(response.resource_response).to eq(params[:body_response][resource.to_url.pluralize])
    end

    context 'with error response' do
      it 'raises an error' do
        expect(mocked_http_client).to receive(:get).with(
          resource.to_url,
          headers: {},
          params: { skip: 0, limit: 100 }
        ).and_return request_response.new(
          status: 400,
          body: params[:error_response]
        )

        expect { resource.fetch! }.to raise_error(Openpix::RubySdk::Resources::RequestError)
      end
    end
  end

  describe '#fetch_next_page!' do
    context 'with fetch being called before' do
      let(:limit) { 5 }
      before do
        expect(mocked_http_client).to receive(:get).with(
          resource.to_url,
          headers: {},
          params: { skip: 0, limit: limit }
        ).and_return request_response.new(
          status: 200,
          body: {
            'pageInfo' => {
              'totalCount' => 10,
              'hasPreviousPage' => more_pages,
              'hasNextPage' => more_pages
            }
          }.merge(params[:body_response])
        )

        resource.fetch(limit: limit)
      end

      context 'having more pages' do
        let(:more_pages) { true }

        it 'fetches next page through http_client get method' do
          expect(mocked_http_client).to receive(:get).with(
            resource.to_url,
            headers: {},
            params: { skip: limit, limit: limit }
          ).and_return request_response.new(
            status: 200,
            body: {
              'pageInfo' => {
                'totalCount' => 10,
                'hasPreviousPage' => more_pages,
                'hasNextPage' => more_pages
              }
            }.merge(params[:body_response])
          )

          response = resource.fetch_next_page!

          expect(response.success?).to eq(true)
          expect(response.resource_response).to eq(params[:body_response][resource.to_url.pluralize])
        end
      end

      context 'without more pages' do
        let(:more_pages) { false }

        it 'raises an error' do
          expect { resource.fetch_next_page! }.to raise_error(Openpix::RubySdk::Resources::PageNotDefinedError)
        end
      end
    end

    context 'without fetch being called before' do
      it 'raises an error' do
        expect { resource.fetch_next_page! }.to raise_error(Openpix::RubySdk::Resources::NotFetchedError)
      end
    end
  end

  describe '#fetch_previous_page!' do
    context 'with fetch being called before' do
      let(:limit) { 5 }
      let(:skip) { 10 }
      before do
        expect(mocked_http_client).to receive(:get).with(
          resource.to_url,
          headers: {},
          params: { skip: skip, limit: limit }
        ).and_return request_response.new(
          status: 200,
          body: {
            'pageInfo' => {
              'totalCount' => 50,
              'hasPreviousPage' => more_pages,
              'hasNextPage' => more_pages
            }
          }.merge(params[:body_response])
        )

        resource.fetch(skip: skip, limit: limit)
      end

      context 'having more pages' do
        let(:more_pages) { true }

        it 'fetches previous page through http_client get method' do
          expect(mocked_http_client).to receive(:get).with(
            resource.to_url,
            headers: {},
            params: { skip: (skip - limit), limit: limit }
          ).and_return request_response.new(
            status: 200,
            body: {
              'pageInfo' => {
                'totalCount' => 50,
                'hasPreviousPage' => more_pages,
                'hasNextPage' => more_pages
              }
            }.merge(params[:body_response])
          )

          response = resource.fetch_previous_page!

          expect(response.success?).to eq(true)
          expect(response.resource_response).to eq(params[:body_response][resource.to_url.pluralize])
        end
      end

      context 'without more pages' do
        let(:more_pages) { false }

        it 'raises an error' do
          expect { resource.fetch_previous_page! }.to raise_error(Openpix::RubySdk::Resources::PageNotDefinedError)
        end
      end
    end

    context 'without fetch being called before' do
      it 'raises an error' do
        expect { resource.fetch_previous_page! }.to raise_error(Openpix::RubySdk::Resources::NotFetchedError)
      end
    end
  end
end
