# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sculptor/version'

Gem::Specification.new do |spec|
  spec.name          = "sculptor"
  spec.version       = Sculptor::VERSION
  spec.authors       = ["Tyom Semonov"]
  spec.email         = ["mail@tyom.net"]
  spec.summary       = "Tool to create style guides and prototype web apps"
  spec.description   = "Styleguide generator, prototype and test tool powered by Middleman"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
