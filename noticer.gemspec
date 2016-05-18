# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'noticer/version'

Gem::Specification.new do |spec|
  spec.name          = "noticer"
  spec.version       = Noticer::VERSION
  spec.authors       = ["Leonardo Alifraco"]
  spec.email         = ["leonardo.alifraco@gmail.com"]

  spec.summary       = "Noticer a gem that allows the emission of notifications using a topic routing algorithm."
  spec.description   = "Noticer a gem that allows the emission of notifications using a topic routing algorithm."
  spec.homepage      = "https://github.com/leonardoalifraco/noticer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
