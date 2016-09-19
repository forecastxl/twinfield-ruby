# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twinfield/version'

Gem::Specification.new do |spec|
  spec.name        = 'twinfield-ruby'
  spec.version     = Twinfield::VERSION
  spec.authors     = ['ForecastXL']
  spec.email       = ['developers@forecastxl.com']
  spec.homepage    = 'https://www.forecastxl.com'
  spec.summary     = 'Ruby client for the Twinfield SOAP-based API'
  spec.description = 'Twinfield is an international Web service for collaborative online accounting. The Twinfield gem is a simple client for their SOAP-based API.'
  spec.license     = 'MIT'

  # Files
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Ruby
  spec.required_ruby_version = '>= 1.9.3'

  # Production
  spec.add_dependency 'savon', '~> 2.11'

  # Development / test
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'pry', '~> 0.10'
end
