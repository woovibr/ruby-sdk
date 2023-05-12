# frozen_string_literal: true

require_relative 'lib/openpix/ruby_sdk/version'

Gem::Specification.new do |spec|
  spec.name = 'openpix-ruby_sdk'
  spec.version = Openpix::RubySdk::VERSION
  spec.authors = ['Erick Takeshi']
  spec.email = ['erick.tmr@outlook.com']

  spec.summary = 'Ruby SDK for OpenPix API'
  spec.description = 'Ruby SDK for OpenPix API'
  spec.homepage = 'https://github.com/Open-Pix/ruby-sdk'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Open-Pix/ruby-sdk'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Dependencies
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.12'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
