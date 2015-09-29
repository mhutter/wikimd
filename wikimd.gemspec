# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wikimd/version'

Gem::Specification.new do |s|
  s.name          = 'wikimd'
  s.version       = WikiMD::VERSION
  s.author        = 'Manuel Hutter'
  s.email         = 'manuel@hutter.io'

  s.summary       = 'WikiMD is an easy-to-use knowledge database.'
  s.description   = 'WikiMD is an easy-to-use knowledge database, which has minimal system dependencies'
  s.homepage      = 'https://github.com/mhutter/wikimd'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").grep(%r{^(bin|lib|wikimd.gemspec|LICENSE|config.ru|README)})
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'fuzzy_set', '~> 1.1'
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'redcarpet'
  s.add_runtime_dependency 'rouge', '~> 1.8', '!= 1.9.1' # 1.9.1 has a loading bug
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'slim'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sass'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard'
end
