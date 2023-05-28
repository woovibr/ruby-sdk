# frozen_string_literal: true

RSpec.shared_examples 'not destroyable resource' do |resource_class|
  let(:resource) { resource_class.new(double('http_client')) }
  let(:id) { 'some-id' }

  describe '#destroy' do
    it 'raises an error' do
      expect { resource.destroy(id: id) }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end

  describe '#destroy!' do
    it 'raises an error' do
      expect { resource.destroy!(id: id) }.to raise_error(Openpix::RubySdk::Resources::ActionNotImplementedError)
    end
  end
end
