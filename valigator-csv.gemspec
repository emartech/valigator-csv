# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'valigator/csv/version'

Gem::Specification.new do |spec|
  spec.name          = 'valigator-csv'
  spec.version       = Valigator::CSV::VERSION
  spec.authors       = ['Daniel Nagy', 'Istvan Demeter', 'Tamas Drahos', 'Milan Unicsovics']
  spec.email         = ['naitodai@gmail.com', 'demeter.istvan@gmail.com', 'drahostamas@gmail.com', 'u.milan@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = %q{Yet another CSV validator library}
  spec.description   = %q{Yet another CSV validator library. Just better.}
  spec.homepage      = 'https://github.com/emartech/valigator-csv'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.8'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", '>= 13.0'
  spec.add_development_dependency "rspec"
end
