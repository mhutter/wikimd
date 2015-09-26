$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'wikimd/app'

# configuration
WikiMD::App.set :repo_path, ENV['REPO_PATH']
run WikiMD::App
