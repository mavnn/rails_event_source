# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_event_source/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_event_source"
  spec.version       = RailsEventSource::VERSION
  spec.authors       = ["Michael Newton"]
  spec.email         = ["michael@mavnn.co.uk"]

  spec.summary       = %q{Use event sourcing to manage your Rails models.}
  spec.description   = %q{Use event sourcing to manage your Rails models.}
  spec.homepage      = "https://github.com/mavnn/rails_event_source"
  spec.license       = "MIT"

  spec.require_paths = ["lib"]

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_dependency "actionpack", "~> 4.2"
  spec.add_development_dependency "rails", "~> 4.2"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "~> 0.9.1"
end
