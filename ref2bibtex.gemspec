# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ref2bibtex/version'

Gem::Specification.new do |spec|
  spec.name          = "ref2bibtex"
  spec.version       = Ref2bibtex::VERSION
  spec.authors       = ["Matt Yoder"]
  spec.email         = ["diapriid@gmail.com"]
  spec.summary       = %q{Pass a full citation, get the bibtex back, that's all.}
  spec.description   = %q{Ok, maybe a bit more, you can pass a DOI and get the bibtex string back too.}
  spec.homepage      = "http://github.com/SpeciesFileGroup/ref2bibtex"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable", "~> 2.6"
  # spec.add_dependency "serrano"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "byebug", "~> 11"
  spec.add_development_dependency "awesome_print", "~> 1.8.0"
  spec.add_development_dependency "rspec", "~> 3.8"

end
