# frozen_string_literal: true

require 'openpix/ruby_sdk/http_client'

RSpec.describe Openpix::RubySdk::HttpClient do
  let(:auth_token) { 'my-token' }

  describe '.instance' do
    it 'returns the instance from HttpClient as a singleton' do
      first_instance = described_class.instance
      second_instance = described_class.instance

      expect(first_instance.object_id).to eq(second_instance.object_id)
    end
  end

  describe '#initialize_http_client' do
    let(:expected_url) { "#{described_class::BASE_URL}#{described_class::API_VERSION}" }
    let(:expected_headers) { { 'Authorization' => auth_token } }

    it 'initializes Faraday client with appropriate url and headers' do
      expect(Faraday).to receive(:new).with(url: expected_url, headers: expected_headers)

      described_class.instance.initialize_http_client(auth_token)
    end

    context 'with custom api url and version' do
      let(:base_url) { 'https://api.com' }
      let(:version) { 'v2' }
      let(:expected_url) { "#{base_url}#{version}" }
      let(:expected_headers) { { 'Authorization' => auth_token } }

      it 'initializes Faraday client with appropriate url and headers' do
        expect(Faraday).to receive(:new).with(url: expected_url, headers: expected_headers)

        described_class.instance.initialize_http_client(auth_token, base_url, version)
      end
    end
  end

  describe '#post' do
    let(:faraday_mock) { double }
    let(:resource) { 'charge' }
    let(:body) { {} }

    before do
      allow(Faraday).to receive(:new).and_return(faraday_mock)
      described_class.instance.initialize_http_client(auth_token)
    end

    it 'calls post method from faraday with resource' do
      expect(faraday_mock).to receive(:post).with(resource)

      described_class.instance.post(resource, body: body)
    end
  end

  describe '#get' do
    let(:faraday_mock) { double }
    let(:resource) { 'charge' }

    before do
      allow(Faraday).to receive(:new).and_return(faraday_mock)
      described_class.instance.initialize_http_client(auth_token)
    end

    it 'calls get method from faraday with resource' do
      expect(faraday_mock).to receive(:get).with(resource)

      described_class.instance.get(resource)
    end
  end

  describe '#delete' do
    let(:faraday_mock) { double }
    let(:resource) { 'charge' }

    before do
      allow(Faraday).to receive(:new).and_return(faraday_mock)
      described_class.instance.initialize_http_client(auth_token)
    end

    it 'calls delete method from faraday with resource' do
      expect(faraday_mock).to receive(:delete).with(resource)

      described_class.instance.delete(resource)
    end
  end
end
