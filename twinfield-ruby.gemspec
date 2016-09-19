# -*- encoding: utf-8 -*-
require File.expand_path("../lib/twinfield/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name        = 'twinfield-ruby'
  spec.version     = Twinfield::VERSION
  spec.licenses    = ['MIT']
  spec.authors     = ['ForecastXL']
  spec.email       = ['developers@forecastxl.com']
  spec.homepage    = 'https://www.forecastxl.com'
  spec.summary     = 'Ruby client for the Twinfield SOAP-based API'
  spec.description = 'Twinfield is an international Web service for collaborative online accounting. The Twinfield gem is a simple client for their SOAP-based API.'

  # Files
  spec.files         = Dir["{lib}/**/*.rb", 'bin/*', '*.md']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Ruby
  spec.required_ruby_version = '>= 1.9.3'

  # Production
  spec.add_runtime_dependency 'savon', '~> 2.11'

  # Development / test
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'pry', '~> 0.10'
end
