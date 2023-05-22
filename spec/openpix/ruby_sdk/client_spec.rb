# frozen_string_literal: true

require 'openpix/ruby_sdk/client'

RSpec.describe Openpix::RubySdk::Client do
  let(:auth_token) { 'my-token' }

  subject { described_class.new(auth_token) }

  describe 'initialization' do
    let(:http_client_mock) { double }

    before { allow(Openpix::RubySdk::HttpClient).to receive(:instance).and_return(http_client_mock) }

    it 'initializes the Http client singleton instance with the auth token' do
      expect(http_client_mock).to receive(:initialize_http_client).with(auth_token)

      subject
    end
  end

  describe 'resources accessor methods' do
    let(:expected_classes) do
      [
        'Openpix::RubySdk::Resources::Charge',
        'Openpix::RubySdk::Resources::Customer',
        'Openpix::RubySdk::Resources::Payment',
        'Openpix::RubySdk::Resources::Refund',
        'Openpix::RubySdk::Resources::Subscription',
        'Openpix::RubySdk::Resources::Webhook'
      ]
    end

    expected_resources = %w[
      charges
      customers
      payments
      refunds
      subscriptions
      webhooks
    ]

    expected_resources.each_with_index do |resource, index|
      it "defines the #{resource} method" do
        expect { subject.send(resource) }.not_to raise_error
      end

      it "returns the #{resource} class instance" do
        expect(subject.send(resource).class.to_s).to eq(expected_classes[index])
      end
    end
  end
end
