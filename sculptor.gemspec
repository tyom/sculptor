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
  spec.homepage      = "http://github.com/tyom/sculptor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "fivemat", "1.2.1"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-cucumber"
  spec.add_development_dependency "pry-plus"

  spec.add_dependency "middleman-core", [">= 3.3", "< 4.0"]
  spec.add_dependency "thor", [">= 0.15.2", "< 2.0"]
  spec.add_dependency "nokogiri", [">= 1.6", "< 2.0"]
end
