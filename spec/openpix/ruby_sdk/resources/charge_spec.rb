# frozen_string_literal: true

RSpec.describe Openpix::RubySdk::Resources::Charge do
  let(:customer) { nil }
  let(:attrs) do
    {
      'correlation_id' => '123',
      'value' => 500,
      'customer' => customer
    }
  end

  subject { described_class.new(attrs) }

  it 'sets its url' do
    expect(subject.to_url).to eq('/charge')
  end

  it 'defines its create attributes' do
    expect(subject.create_attributes).to eq(Openpix::RubySdk::Resources::Charge::ATTRS)
  end

  describe 'customer' do
    context 'without customer' do
      it 'pass validation' do
        expect do
          subject
        end.to_not raise_error
      end
    end

    context 'with an object that is not a Customer' do
      let(:customer) { { 'name' => 'Nameless' } }

      it 'raises ArgumentError' do
        expect do
          subject
        end.to raise_error(ArgumentError, 'customer must be an instance of Openpix::RubySdk::Resources::Customer')
      end
    end

    context 'with a Customer object' do
    end
  end
end
