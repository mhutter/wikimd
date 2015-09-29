require 'wikimd/app'
require 'rack/test'

RSpec.describe WikiMD::App do
  include Rack::Test::Methods

  let(:app) { WikiMD::App }
  before do
    WikiMD::App.set :repo_path, TMP_REPO_PATH
  end

  describe '/search.json' do
    it 'returns JSON data' do
      get '/search.json?query=foo'
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq 'application/json'
    end

    it 'returns matches' do
      init_tmp_repo
      %w{A B C}.each do |l|
        TMP_REPO_PATH.join("file#{l}").write(' ')
      end

      get '/search.json?query=file'
      expect(last_response).to be_ok
      expect(last_response.body).to include('fileA')
      expect(last_response.body).to include('fileB')
      expect(last_response.body).to include('fileC')
    end
  end

  describe '404' do
    it 'renders the 404 page' do
      get '/does/not/exist'
      expect(last_response).to be_not_found
      expect(last_response.body).to include('File not found')
    end
  end
end
