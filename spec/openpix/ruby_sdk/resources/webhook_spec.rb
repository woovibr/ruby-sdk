# frozen_string_literal: true

require_relative 'shared/savable_resource'
require_relative 'shared/fetchable_resource'
require_relative 'shared/destroyable_resource'
require_relative 'shared/not_findable_resource'
require 'openpix/ruby_sdk/resources/webhook'

RSpec.describe Openpix::RubySdk::Resources::Webhook do
  savable_params = {
    resource_class: described_class,
    attrs: {
      'name' => 'my webhook create',
      'event' => 'OPENPIX:CHARGE_CREATED',
      'url' => 'https://mycompany.com.br/webhook',
      'authorization' => 'openpix',
      'isActive' => false
    },
    body_response: {
      'webhook' => {
        'id' => 'V2ViaG9vazo2MDNlYmUxZWRlYjkzNWU4NmQyMmNmMTg=',
        'name' => 'my webhook create',
        'url' => 'https://mycompany.com.br/webhook',
        'authorization' => 'openpix',
        'isActive' => false,
        'event' => 'OPENPIX:CHARGE_CREATED',
        'createdAt' => '2021-03-02T22:29:10.720Z',
        'updatedAt' => '2021-03-02T22:29:10.720Z'
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
      'webhooks' => [
        {
          'id' => 'V2ViaG9vazo2MDNlYmUxZWRlYjkzNWU4NmQyMmNmMTg=',
          'name' => 'my webhook create',
          'url' => 'https://mycompany.com.br/webhook',
          'authorization' => 'openpix',
          'isActive' => false,
          'event' => 'OPENPIX:CHARGE_CREATED',
          'createdAt' => '2021-03-02T22:29:10.720Z',
          'updatedAt' => '2021-03-02T22:29:10.720Z'
        }
      ]
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'fetchable resource', fetchable_params

  destroyable_params = {
    resource_class: described_class,
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'destroyable resource', destroyable_params

  it_behaves_like 'not findable resource', described_class

  let(:attrs) do
    {
      'name' => 'my webhook create',
      'event' => 'OPENPIX:CHARGE_CREATED',
      'url' => 'https://mycompany.com.br/webhook',
      'authorization' => 'openpix',
      'isActive' => false
    }
  end

  subject { described_class.new(double('http_client')) }

  it 'sets its url' do
    expect(subject.to_url).to eq('webhook')
  end

  it 'defines its create attributes' do
    expect(subject.create_attributes).to eq(Openpix::RubySdk::Resources::Webhook::ATTRS)
  end

  describe '#init_body' do
    it 'sets the attrs defined by the ATTRS constant' do
      subject.init_body(params: attrs)

      expect(subject.name).to eq(attrs['name'])
      expect(subject.event).to eq(attrs['event'])
      expect(subject.url).to eq(attrs['url'])
      expect(subject.authorization).to eq(attrs['authorization'])
      expect(subject.isActive).to eq(attrs['isActive'])
    end
  end

  describe '#to_body' do
    before { subject.init_body(params: attrs) }

    let(:expected_body) do
      {
        webhook: {
          'name' => attrs['name'],
          'url' => attrs['url'],
          'authorization' => attrs['authorization'],
          'isActive' => attrs['isActive'],
          'event' => attrs['event']
        }
      }
    end

    it 'parses all fields as expected' do
      expect(subject.to_body).to eq(expected_body)
    end
  end
end
