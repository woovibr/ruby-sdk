# frozen_string_literal: true

RSpec.shared_examples 'not fetchable resource' do |resource_class|
  let(:resource) { resource_class.new(double('http_client')) }
  let(:id) { 'some-id' }

  describe '#fetch' do
    it 'raises an error' do
      expect { resource.fetch }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end

  describe '#fetch!' do
    it 'raises an error' do
      expect { resource.fetch! }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end

  describe '#fetch_next_page!' do
    it 'raises an error' do
      expect { resource.fetch_next_page! }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end

  describe '#fetch_previous_page!' do
    it 'raises an error' do
      expect { resource.fetch_previous_page! }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end
end
