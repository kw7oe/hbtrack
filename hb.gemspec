# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hb/version'

Gem::Specification.new do |spec|
  spec.name          = 'hb'
  spec.version       = Hb::VERSION
  spec.authors       = ['kw7oe']
  spec.email         = ['choongkwern@hotmail.com']

  spec.summary       = 'A CLI to track your habits.'
  spec.description   = 'Habit Tracker CLI'
  spec.homepage      = "https://github.com/kw7oe/hb"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake', '~> 10.0'
end
