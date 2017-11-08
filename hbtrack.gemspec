# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hbtrack/version'

Gem::Specification.new do |spec|
  spec.name          = 'hbtrack'
  spec.version       = Hbtrack::VERSION
  spec.authors       = ['kw7oe']
  spec.email         = ['choongkwern@hotmail.com']

  spec.summary       = 'A CLI to track your habits.'
  spec.description   = 'Habit Tracker CLI'
  spec.homepage      = 'https://github.com/kw7oe/hbtrack'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rake', '~> 10.0'
end
