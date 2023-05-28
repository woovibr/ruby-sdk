# frozen_string_literal: true

RSpec.shared_examples 'not findable resource' do |resource_class|
  let(:resource) { resource_class.new(double('http_client')) }
  let(:id) { 'some-id' }

  describe '#find' do
    it 'raises an error' do
      expect { resource.find(id: id) }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end

  describe '#find!' do
    it 'raises an error' do
      expect { resource.find!(id: id) }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end
end
