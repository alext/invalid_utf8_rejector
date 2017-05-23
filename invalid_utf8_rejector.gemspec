# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invalid_utf8_rejector/version'

Gem::Specification.new do |spec|
  spec.name          = "invalid_utf8_rejector"
  spec.version       = InvalidUTF8Rejector::VERSION
  spec.authors       = ["Alex Tomlins"]
  spec.email         = ["alex@tomlins.org.uk"]
  spec.description   = %q{rack middleware to reject invalid UTF8 in requests.  It will return a 400 if the decoded path or query string contain invalid UTF-8 chars.}
  spec.summary       = %q{rack middleware to reject invalid UTF8 in requests}
  spec.homepage      = "https://github.com/alext/invalid_utf8_rejector"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test", "0.6.3"
  spec.add_development_dependency "rspec", "3.6.0"
end
