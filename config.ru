$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'wikimd/app'

# configuration
WikiMD::App.set :repo, '/tmp/test_repo'
run WikiMD::App
