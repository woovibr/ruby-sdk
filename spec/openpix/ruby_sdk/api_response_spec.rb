# frozen_string_literal: true

require 'openpix/ruby_sdk/api_response'

RSpec.describe Openpix::RubySdk::ApiResponse do
  let(:status) { nil }
  let(:resource_response) { nil }
  let(:error_response) { nil }
  let(:pagination_meta) { nil }

  subject do
    described_class.new(
      status: status,
      resource_response: resource_response,
      error_response: error_response,
      pagination_meta: pagination_meta
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
end
