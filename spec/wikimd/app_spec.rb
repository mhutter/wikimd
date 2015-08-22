require 'rack/test'
require 'wikimd/app'

RSpec.describe WikiMD::App do
  include Rack::Test::Methods
  let(:app) { WikiMD::App }
  # def app
  #   WikiMD::App
  # end

  before do
    WikiMD::App.set :repo, File.expand_path('../fixtures/repo', __FILE__)
  end

  describe 'GET /' do
    it 'returns something' do
      get '/'
      expect(last_response.body).to match /WikiMD/
      expect(last_response.status).to eq 200
    end
  end

  describe 'GET /syntax.css' do
    it 'renders Syntax highlighting CSS' do
      get '/syntax.css'
      expect(last_response.status).to eq 200
      expect(last_response.body).to include '.highlight {'
      expect(last_response.header['Content-Type']).to eq 'text/css'
    end
  end
end
