# frozen_string_literal: true

require_relative 'shared/savable_resource'
require_relative 'shared/fetchable_resource'
require_relative 'shared/findable_resource'
require_relative 'shared/not_destroyable_resource'
require 'openpix/ruby_sdk/resources/refund'

RSpec.describe Openpix::RubySdk::Resources::Refund do
  savable_params = {
    resource_class: described_class,
    attrs: {
      'value' => 4000,
      'correlation_id' => '1234',
      'transaction_end_to_end_id' => '123'
    },
    body_response: {
      'refund' => {
        'value' => 4000,
        'status' => 'IN_PROCESSING',
        'correlationID' => '1234',
        'sourceAccountId' => '123',
        'time' => '2021-03-02T17:28:51.882Z'
      }
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'savable resource', savable_params

  fetchable_params = {
    resource_class: described_class,
    body_response: {
      'refunds' => [
        {
          'value' => 4000,
          'status' => 'IN_PROCESSING',
          'correlationID' => '1234',
          'sourceAccountId' => '123',
          'time' => '2021-03-02T17:28:51.882Z'
        }
      ]
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'fetchable resource', fetchable_params

  findable_params = {
    resource_class: described_class,
    body_response: {
      'refund' => {
        'value' => 4000,
        'status' => 'IN_PROCESSING',
        'correlationID' => '1234',
        'sourceAccountId' => '123',
        'time' => '2021-03-02T17:28:51.882Z'
      }
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'findable resource', findable_params

  it_behaves_like 'not destroyable resource', described_class

  let(:transaction_end_to_end_id) { nil }
  let(:attrs) do
    {
      'value' => 4000,
      'correlation_id' => '1234',
      'transaction_end_to_end_id' => transaction_end_to_end_id
    }
  end

  subject { described_class.new(double('http_client')) }

  it 'sets its url' do
    expect(subject.to_url).to eq('refund')
  end

  it 'defines its create attributes' do
    expect(subject.create_attributes).to eq(Openpix::RubySdk::Resources::Refund::ATTRS)
  end

  describe '#init_body' do
    it 'sets the attrs defined by the ATTRS constant' do
      subject.init_body(params: attrs)

      expect(subject.value).to eq(attrs['value'])
      expect(subject.correlation_id).to eq(attrs['correlation_id'])
      expect(subject.transaction_end_to_end_id).to eq(transaction_end_to_end_id)
      expect(subject.comment).to eq(nil)
    end
  end

  describe '#to_body' do
    before { subject.init_body(params: attrs) }

    context 'without transaction_end_to_end_id' do
      let(:expected_body) do
        {
          'value' => attrs['value'],
          'correlationID' => attrs['correlation_id']
        }
      end

      it 'parses other fields normally' do
        expect(subject.to_body).to eq(expected_body)
      end
    end

    context 'with transaction_end_to_end_id' do
      let(:transaction_end_to_end_id) { '123' }
      let(:expected_body) do
        {
          'value' => attrs['value'],
          'correlationID' => attrs['correlation_id'],
          'transactionEndToEndId' => attrs['transaction_end_to_end_id']
        }
      end

      it 'parses transaction_end_to_end_id as expected' do
        expect(subject.to_body).to eq(expected_body)
      end
    end
  end
end
