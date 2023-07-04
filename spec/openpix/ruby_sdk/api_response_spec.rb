# frozen_string_literal: true

require 'openpix/ruby_sdk/api_response'

RSpec.describe Openpix::RubySdk::ApiResponse do
  let(:status) { nil }
  let(:body) { {} }
  let(:single_resource) { nil }
  let(:collection_resource) { nil }

  subject do
    described_class.new(
      status: status,
      body: body,
      single_resource: single_resource,
      collection_resource: collection_resource
    )
  end

  context 'with status 200' do
    let(:status) { 200 }

    describe '#success' do
      it 'returns true' do
        expect(subject.success).to eq(true)
      end
    end
  end

  context 'with status != 200' do
    let(:status) { 400 }

    describe '#success' do
      it 'returns false' do
        expect(subject.success).to eq(false)
      end
    end
  end

  describe '#resource_response' do
    context 'with single resource' do
      let(:single_resource) { 'charge' }
      let(:resource) { { 'key' => 'value' } }
      let(:body) { { 'charge' => resource } }

      it 'returns resource' do
        expect(subject.resource_response).to eq(resource)
      end
    end

    context 'with collection resource' do
      let(:collection_resource) { 'charges' }
      let(:resource) { [{ 'key' => 'value' }] }
      let(:body) { { 'charges' => resource } }

      it 'returns resources collection' do
        expect(subject.resource_response).to eq(resource)
      end
    end
  end

  describe '#error_response' do
    context 'without errors' do
      let(:resource) { { 'key' => 'value' } }
      let(:body) { { 'charge' => resource } }

      it 'returns empty string' do
        expect(subject.error_response).to eq('')
      end
    end

    context 'with error key' do
      let(:error_msg) { 'Error msg' }
      let(:body) { { 'error' => error_msg } }

      it 'returns error msg' do
        expect(subject.error_response).to eq(error_msg)
      end
    end

    context 'with errors key' do
      let(:error_msg) { 'Error msg' }
      let(:body) { { 'errors' => [{ 'message' => error_msg }] } }

      it 'returns error msg' do
        expect(subject.error_response).to eq(error_msg)
      end
    end
  end

  describe '#pagination_meta' do
    context 'with pageInfo present' do
      let(:pagination_values) { { 'has_next_page' => true } }
      let(:body) { { 'pageInfo' => pagination_values } }

      it 'returns pagination data' do
        expect(subject.pagination_meta).to eq(pagination_values)
      end
    end

    context 'without pageInfo' do
      it 'returns empty hash' do
        expect(subject.pagination_meta).to eq({})
      end
    end
  end
end
