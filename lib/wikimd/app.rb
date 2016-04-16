require 'json'

require 'fuzzy_set'
require 'sinatra/base'
require 'slim'

require 'wikimd/renderer'
require 'wikimd/repository'

module WikiMD
  # Main Sinatra application
  class App < Sinatra::Base
    TYPE_MARKDOWN = %w(md mdown markdown)
    TYPE_TEXT = %w(txt rb js slim css scss coffee)

    # Use gzip compression
    use Rack::Deflater

    configure do
      # disable stuff not needed
      disable :method_override

      enable :sessions

      set :views, File.expand_path('../app/views', __FILE__)
      set :markdown_renderer, WikiMD::Renderer.build
      set :public_folder, File.expand_path('../app/public', __FILE__)

      set :fs_created, Time.new(0)
      set :fs, nil
      set(:repo) { WikiMD::Repository.new(settings.repo_path) }
    end

    # :nocov:
    configure :development do
      # settings for easier debugging
      Slim::Engine.set_options pretty: true, sort_attrs: false
      set :show_exceptions, :after_handler
    end
    # :nocov:

    helpers do
      # returns the URI for a static asset.
      #
      # @param name [#to_s] name of the asset file
      # @return [String] the full URI
      def asset_path(name)
        url("assets/#{name}")
      end

      # Include an Octicon! (see https://octicons.github.com/)
      #
      # @param name [#to_s] Name of the Octicon
      # @return [String] HTML Code for the Octicon
      def octicon(name)
        %(<span class="octicon octicon-#{name}"></span>)
      end

      # Get the directory-Tree from the root of the repo
      def tree_root
        repo.tree
      end

      # URL helper for the History page of a document
      #
      # @param path [String] relative path of the document in the Repository
      # @return [String] full URI to the history page
      def history_path(path)
        url('/h/' + path)
      end

      # URL helper for the Edit page of a document
      #
      # @param path [String] relative path of the document in the Repository
      # @return [String] full URI to the edit page
      def edit_path(path)
        url('/e/' + path)
      end

      # CSS class for a diff line
      #
      # @param line [String] the line in question
      # @return [String] "addition", if the line starts with "+", "removal" if
      #   the line starts with "-", nil otherwise.
      def class_for_diff(line)
        case line[0]
        when '+'
          'addition'
        when '-'
          'removal'
        end
      end
    end

    # If no route matches, render the 404 page
    not_found do
      @path = env['PATH_INFO'].sub(%r{^/([ceh]/)?}, '')
      slim :'404'
    end

    before do
      @flash = session[:flash]
      session[:flash] = nil
    end

    get('/') { redirect to('index.md') }

    post '/c/*' do |path|
      if (params[:compare] || []).length != 2
        session[:flash] = {
          'error' => 'Must select exactly 2 revisions!'
        }
        redirect to('/h/' + path)
      end

      @from, @to = params['compare'][1], params['compare'][0]
      begin
        @diff = repo.diff(path, @from, @to)
      rescue WikiMD::Repository::FileNotFound
        pass
      end

      @path = path
      slim :diff
    end

    # Quick/Fuzzy Search
    get '/search.json' do
      headers 'Content-Type' => 'application/json'
      files_set.get(params[:query]).to_json
    end

    # History Page
    get '/h/*' do |path|
      @path = path
      begin
        @history = repo.history(@path)
      rescue WikiMD::Repository::GitError
        @history = []
      end
      slim :history
    end

    # Update
    post '/e/*' do |path|
      repo.update(path, params[:content])
      session[:flash] = { 'info' => "'#{path}' has been saved!" }
      redirect to(path)
    end

    # Edit page
    get '/e/*' do |path|
      begin
        @content = repo.read(path)
      rescue WikiMD::Repository::FileNotFound
        pass
      end
      @path = path
      slim :edit
    end

    # Document Page
    get '/*' do |path|
      begin
        @content = repo.read(path, params[:at])
      rescue WikiMD::Repository::FileNotFound
        pass
      end
      @path = path
      @extension = (m = path.match(/(?:\.)([^.]+)$/)) ? m[1].downcase : ''
      slim :file
    end

    private

    # Render Markdown to HTML
    def render_markdown(markdown)
      settings.markdown_renderer.render(markdown)
    end

    # create or return Repository
    def repo
      settings.repo
    end

    # create or return the Search Index
    def files_set
      if settings.fs_created + 12 < Time.now
        settings.fs = FuzzySet.new(repo.files)
        settings.fs_created = Time.now
      end
      settings.fs
    end
  end
end
