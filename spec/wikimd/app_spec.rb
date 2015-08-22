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

  describe 'GET /a_file.md' do
    before(:each) do
      @repo = double('repo')
      allow(WikiMD::Repository).to receive(:new) { @repo }
    end

    it 'returns the content of the given file' do
      expect(@repo).to receive(:read).with('a_file.md').and_return('# A File!')
      get '/a_file.md'
      expect(last_response.status).to eq 200
      expect(last_response.body).to include('<h1>A File!</h1>')
    end

    it 'returns 404 if the file does not exist' do
      expect(@repo).to receive(:read)
        .and_raise(WikiMD::Repository::FileNotFound)

      get '/something.md'
      expect(last_response.status).to eq 404
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
