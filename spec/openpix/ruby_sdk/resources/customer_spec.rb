# frozen_string_literal: true

require_relative 'shared/savable_resource'
require_relative 'shared/fetchable_resource'
require_relative 'shared/findable_resource'
require_relative 'shared/not_destroyable_resource'
require 'openpix/ruby_sdk/resources/customer'

RSpec.describe Openpix::RubySdk::Resources::Customer do
  savable_params = {
    resource_class: described_class,
    attrs: {
      'name' => 'My Name',
      'tax_id' => '99812628000159'
    },
    body_response: {
      'customer' => {
        'name' => 'My Name',
        'taxID' => {
          'taxID' => '99812628000159',
          'type' => 'BR:CNPJ'
        }
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
      'customers' => [
        {
          'name' => 'My Name',
          'taxID' => {
            'taxID' => '99812628000159',
            'type' => 'BR:CNPJ'
          }
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
      'customer' => {
        'name' => 'My Name',
        'taxID' => {
          'taxID' => '99812628000159',
          'type' => 'BR:CNPJ'
        }
      }
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'findable resource', findable_params

  it_behaves_like 'not destroyable resource', described_class

  let(:address) { nil }
  let(:attrs) do
    {
      'name' => 'My Name',
      'tax_id' => '99812628000159',
      'address' => address
    }
  end

  subject { described_class.new(double('http_client')) }

  it 'sets its url' do
    expect(subject.to_url).to eq('customer')
  end

  it 'defines its create attributes' do
    expect(subject.create_attributes).to eq(Openpix::RubySdk::Resources::Customer::ATTRS)
  end

  describe '#init_body' do
    it 'sets the attrs defined by the ATTRS constant' do
      subject.init_body(params: attrs)

      expect(subject.name).to eq(attrs['name'])
      expect(subject.tax_id).to eq(attrs['tax_id'])
      expect(subject.email).to eq(nil)
    end
  end

  describe '#to_body' do
    before { subject.init_body(params: attrs) }

    context 'without address' do
      let(:expected_body) do
        {
          'name' => attrs['name'],
          'taxID' => attrs['tax_id']
        }
      end

      it 'parses other fields normally' do
        expect(subject.to_body).to eq(expected_body)
      end
    end

    context 'with empty hash address' do
      let(:address) { {} }
      let(:expected_body) do
        {
          'name' => attrs['name'],
          'taxID' => attrs['tax_id']
        }
      end

      it 'parses other fields normally' do
        expect(subject.to_body).to eq(expected_body)
      end
    end

    context 'with address' do
      let(:address) do
        {
          country: 'Brasil',
          zipcode: '02145123',
          street: 'Rua minharua',
          number: 123
        }
      end
      let(:expected_body) do
        {
          'name' => attrs['name'],
          'taxID' => attrs['tax_id'],
          'address' => {
            'country' => address[:country],
            'zipcode' => address[:zipcode],
            'street' => address[:street],
            'number' => address[:number]
          }
        }
      end

      it 'parses customer and address body normally' do
        expect(subject.to_body).to eq(expected_body)
      end
    end
  end
end
