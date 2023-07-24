# frozen_string_literal: true

require_relative 'shared/savable_resource'
require_relative 'shared/fetchable_resource'
require_relative 'shared/findable_resource'
require_relative 'shared/destroyable_resource'
require 'openpix/ruby_sdk/resources/charge'

RSpec.describe Openpix::RubySdk::Resources::Charge do
  savable_params = {
    resource_class: described_class,
    attrs: {
      'correlationID' => '123',
      'value' => 500
    },
    body_response: {
      'charge' => {
        'status' => 'ACTIVE',
        'value' => 500,
        'correlationID' => '123'
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
      'charges' => [
        {
          'status' => 'ACTIVE',
          'value' => 500,
          'correlationID' => '123'
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
      'charge' => {
        'status' => 'ACTIVE',
        'value' => 500,
        'correlationID' => '123'
      }
    },
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'findable resource', findable_params

  destroyable_params = {
    resource_class: described_class,
    error_response: {
      'error' => 'error from API charge'
    }
  }
  it_behaves_like 'destroyable resource', destroyable_params

  let(:customer) { nil }
  let(:attrs) do
    {
      'correlationID' => '123',
      'value' => 500,
      'customer' => customer
    }
  end

  subject { described_class.new(double('http_client')) }

  it 'sets its url' do
    expect(subject.to_url).to eq('charge')
  end

  it 'defines its create attributes' do
    expect(subject.create_attributes).to eq(Openpix::RubySdk::Resources::Charge::ATTRS)
  end

  describe '#init_body' do
    it 'sets the attrs defined by the ATTRS constant' do
      subject.init_body(params: attrs)

      expect(subject.correlationID).to eq(attrs['correlationID'])
      expect(subject.value).to eq(attrs['value'])
      expect(subject.customer).to eq(attrs['customer'])
      expect(subject.comment).to eq(nil)
    end
  end

  describe '#to_body' do
    before { subject.init_body(params: attrs) }

    context 'without customer' do
      let(:expected_body) do
        {
          'correlationID' => attrs['correlationID'],
          'value' => attrs['value']
        }
      end

      it 'parses other fields normally' do
        expect(subject.to_body).to eq(expected_body)
      end
    end

    context 'with empty hash customer' do
      let(:customer) { {} }
      let(:expected_body) do
        {
          'correlationID' => attrs['correlationID'],
          'value' => attrs['value']
        }
      end

      it 'parses other fields normally' do
        expect(subject.to_body).to eq(expected_body)
      end
    end

    context 'with customer' do
      let(:address) { nil }
      let(:customer) do
        {
          name: 'My Name',
          taxID: '44406223412',
          address: address
        }
      end

      context 'without address' do
        let(:expected_body) do
          {
            'correlationID' => attrs['correlationID'],
            'value' => attrs['value'],
            'customer' => {
              'name' => customer[:name],
              'taxID' => customer[:taxID]
            }
          }
        end

        it 'parses customer body normally' do
          expect(subject.to_body).to eq(expected_body)
        end
      end

      context 'with empty hash address' do
        let(:address) { {} }
        let(:expected_body) do
          {
            'correlationID' => attrs['correlationID'],
            'value' => attrs['value'],
            'customer' => {
              'name' => customer[:name],
              'taxID' => customer[:taxID]
            }
          }
        end

        it 'parses customer body normally' do
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
            'correlationID' => attrs['correlationID'],
            'value' => attrs['value'],
            'customer' => {
              'name' => customer[:name],
              'taxID' => customer[:taxID],
              'address' => {
                'country' => address[:country],
                'zipcode' => address[:zipcode],
                'street' => address[:street],
                'number' => address[:number]
              }
            }
          }
        end

        it 'parses customer and address body normally' do
          expect(subject.to_body).to eq(expected_body)
        end
      end
    end
  end

  describe '#add_additional_info' do
    before { subject.init_body(params: attrs) }

    it 'adds a new key value pair to the additional_info request body' do
      expect(subject.additionalInfo).to be_nil

      subject.add_additional_info('venda', 'shiba blocks toy')

      expect(subject.additionalInfo).to eq([{ 'key' => 'venda', 'value' => 'shiba blocks toy' }])
    end
  end

  describe '#set_interests' do
    before { subject.init_body(params: attrs) }

    it 'sets the interests attr' do
      subject.set_interests(0.2)

      expect(subject.interests).to eq({ 'value' => 0.2 })
    end
  end

  describe '#set_fines' do
    before { subject.init_body(params: attrs) }

    it 'sets the interests attr' do
      subject.set_fines(0.2)

      expect(subject.fines).to eq({ 'value' => 0.2 })
    end
  end
end
