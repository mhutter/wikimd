require 'rack/test'
require 'wikimd/app'

RSpec.describe WikiMD::App do
  include Rack::Test::Methods
  let(:app) { WikiMD::App }
  # def app
  #   WikiMD::App
  # end

  before do
    WikiMD::App.set :repo, ''
    @repo = double('repo')
    allow(WikiMD::Repository).to receive(:new) { @repo }
  end

  describe 'GET /' do
    it 'returns something' do
      get '/'
      expect(last_response.body).to match /WikiMD/
      expect(last_response.status).to eq 200
    end
  end

  describe 'GET /folder/' do
    let(:dirs) { %w(foo/ bar/ baz/) }
    let(:files) { %w(doc.txt foo.md bar.md) }

    before(:each) do
      allow(@repo).to receive(:list_dirs).with('folder').and_return(dirs)
      allow(@repo).to receive(:list_files).with('folder').and_return(files)
      get '/folder/'
    end

    it 'returns a list of dirs' do
      expect(last_response.body).to match /#{dirs.sort.join('.*')}/
    end

    it 'returns a list of files' do
      expect(last_response.body).to match /#{files.sort.join('.*')}/
    end
  end

  describe 'GET /a_file.md' do
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
end
