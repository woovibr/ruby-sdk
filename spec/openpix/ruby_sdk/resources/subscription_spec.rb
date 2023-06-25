# frozen_string_literal: true

require_relative 'shared/savable_resource'
require_relative 'shared/findable_resource'
require_relative 'shared/not_destroyable_resource'
require_relative 'shared/not_fetchable_resource'
require 'openpix/ruby_sdk/resources/subscription'

RSpec.describe Openpix::RubySdk::Resources::Subscription do
  savable_params = {
    resource_class: described_class,
    attrs: {
      'value' => 4000,
      'customer' => {
        'name' => 'Customer Name',
        'tax_id' => '31324227036'
      }
    },
    body_response: {
      'subscription' => {
        'globalID' => 'UGF5bWVudFN1YnNjcmlwdGlvbjo2M2UzYjJiNzczZDNkOTNiY2RkMzI5OTM=',
        'value' => 4000,
        'dayGenerateCharge' => 5,
        'customer' => {
          'name' => 'Customer Name',
          'taxID' => {
            'taxID' => '31324227036',
            'type' => 'BR:CPF'
          }
        }
      }
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'savable resource', savable_params

  findable_params = {
    resource_class: described_class,
    body_response: {
      'subscription' => {
        'globalID' => 'UGF5bWVudFN1YnNjcmlwdGlvbjo2M2UzYjJiNzczZDNkOTNiY2RkMzI5OTM=',
        'value' => 4000,
        'dayGenerateCharge' => 5,
        'customer' => {
          'name' => 'Customer Name',
          'taxID' => {
            'taxID' => '31324227036',
            'type' => 'BR:CPF'
          }
        }
      }
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'findable resource', findable_params

  it_behaves_like 'not destroyable resource', described_class
  it_behaves_like 'not fetchable resource', described_class

  let(:attrs) do
    {
      'value' => 4000,
      'customer' => {
        'name' => 'Customer Name',
        'tax_id' => '31324227036'
      }
    }
  end

  subject { described_class.new(double('http_client')) }

  it 'sets its url' do
    expect(subject.to_url).to eq('subscriptions')
  end

  it 'defines its create attributes' do
    expect(subject.create_attributes).to eq(Openpix::RubySdk::Resources::Subscription::ATTRS)
  end

  describe '#init_body' do
    it 'sets the attrs defined by the ATTRS constant' do
      subject.init_body(params: attrs)

      expect(subject.value).to eq(attrs['value'])
      expect(subject.customer).to eq(attrs['customer'])
      expect(subject.day_generate_charge).to eq(nil)
    end
  end

  describe '#to_body' do
    before { subject.init_body(params: attrs) }

    let(:expected_body) do
      {
        'value' => attrs['value'],
        'customer' => {
          'name' => attrs['customer']['name'],
          'taxID' => attrs['customer']['tax_id']
        }
      }
    end

    it 'parses all the fields correctly' do
      expect(subject.to_body).to eq(expected_body)
    end
  end
end
