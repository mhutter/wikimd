require 'simplecov'

REPO_PATH = Pathname(Dir.tmpdir).join($$.to_s)
ENV['REPO_PATH'] = REPO_PATH.to_s
ENV['RACK_ENV'] = 'test'

require 'rack/test'
# require 'rspec/expectations'
require 'wikimd'

WikiMD::App.set :environment, :test
WikiMD::App.set :repo_path, REPO_PATH.to_s

include Rack::Test::Methods
def app
  WikiMD::App
end
