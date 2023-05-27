# frozen_string_literal: true

require 'ostruct'

RSpec.shared_examples 'savable resource' do |params|
  let(:mocked_http_client) { double('http_client') }
  let(:resource) { params[:resource_class].new(mocked_http_client) }

  before { resource.init_body(params: params[:attrs]) }

  describe '#save' do
    it 'saves the resource through http_client post method' do
      expect(mocked_http_client).to receive(:post).with(
        resource.to_url,
        body: resource.to_body,
        headers: {},
        params: { return_existing: false }
      ).and_return OpenStruct.new(
        status: 200,
        body: params[:body_response]
      )

      response = resource.save

      expect(response.success?).to eq(true)
      expect(response.resource_response).to eq(params[:body_response][resource.to_single_resource])
    end

    context 'with error response' do
      it 'returns success false and sets the error msg' do
        expect(mocked_http_client).to receive(:post).with(
          resource.to_url,
          body: resource.to_body,
          headers: {},
          params: { return_existing: false }
        ).and_return OpenStruct.new(
          status: 400,
          body: params[:error_response]
        )

        response = resource.save

        expect(response.success?).to eq(false)
        expect(response.error_response).to eq(params[:error_response]['error'])
      end
    end
  end

  describe '#save!' do
    it 'saves the resource through http_client post method' do
      expect(mocked_http_client).to receive(:post).with(
        resource.to_url,
        body: resource.to_body,
        headers: {},
        params: { return_existing: false }
      ).and_return OpenStruct.new(
        status: 200,
        body: params[:body_response]
      )

      response = resource.save!

      expect(response.success?).to eq(true)
      expect(response.resource_response).to eq(params[:body_response][resource.to_single_resource])
    end

    context 'with error response' do
      it 'raises an error' do
        expect(mocked_http_client).to receive(:post).with(
          resource.to_url,
          body: resource.to_body,
          headers: {},
          params: { return_existing: false }
        ).and_return OpenStruct.new(
          status: 400,
          body: params[:error_response]
        )

        expect { resource.save! }.to raise_error(Openpix::RubySdk::Resources::RequestError)
      end
    end
  end
end
