$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'wikimd/app'

# configuration
WikiMD::App.set :repo, File.expand_path('../spec/fixtures/repo', __FILE__)
run WikiMD::App
