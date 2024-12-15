# frozen_string_literal: true

require_relative 'lib/openpix/ruby_sdk/version'

Gem::Specification.new do |spec|
  spec.name = 'openpix-ruby_sdk'
  spec.version = Openpix::RubySdk::VERSION
  spec.authors = ['Erick Takeshi']
  spec.email = ['erick.tmr@outlook.com']

  spec.summary = 'Ruby SDK for OpenPix/Woovi API'
  spec.description = 'Ruby SDK for OpenPix/Woovi API'
  spec.homepage = 'https://github.com/Open-Pix/ruby-sdk'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Open-Pix/ruby-sdk'
  spec.metadata['changelog_uri'] = 'https://github.com/Open-Pix/ruby-sdk/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md']

  # Dependencies
  spec.add_dependency 'activesupport', '>= 6.1'
  spec.add_dependency 'faraday', '~> 2.7', '>= 2.7.4'
  spec.add_dependency 'faraday-httpclient', '~> 2.0', '>= 2.0.1'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack', '~> 3.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.50'
  spec.add_development_dependency 'webrick', '~> 1.8'
  spec.add_development_dependency 'yard', '~> 0.9.34'
end
