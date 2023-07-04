# frozen_string_literal: true

require 'openpix/ruby_sdk'

RSpec.describe Openpix::RubySdk do
  it 'has a version number' do
    expect(Openpix::RubySdk::VERSION).not_to be nil
  end
end
