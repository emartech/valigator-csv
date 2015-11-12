# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_validator/version'

Gem::Specification.new do |spec|
  spec.name          = 'csv_validator'
  spec.version       = CsvValidator::VERSION
  spec.authors       = ['Istvan Demeter', 'Daniel Nagy']
  spec.email         = %w(demeter.istvan@gmail.com naitodai@gmail.com)

  spec.summary       = %q{Yet another CSV validator library}
  spec.description   = %q{Yet another CSV validator library. Just better.}
  spec.homepage      = 'https://github.com/emartech/csv_validator'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
