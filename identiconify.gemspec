# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'identiconify/version'

Gem::Specification.new do |spec|
  spec.name          = "identiconify"
  spec.version       = Identiconify::VERSION
  spec.authors       = ["calleerlandsson"]
  spec.email         = ["calle@omnidev.se"]
  spec.description   = "Identiconify makes it super simple to generate "\
                       "identicons representing string values such as "\
                       "usernames or ip addresses."
  spec.summary       = "Super simple identicons"
  spec.homepage      = "https://github.com/calleerlandsson/identiconify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'chunky_png', '~> 1.2', '>= 1.2.9'
end
