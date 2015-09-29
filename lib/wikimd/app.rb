require 'json'

require 'sinatra/base'
require 'fuzzy_set'
require 'slim'

require 'wikimd/renderer'
require 'wikimd/repository'

module WikiMD
  # Main Sinatra application
  class App < Sinatra::Base
    TYPE_MARKDOWN = %w(md mdown markdown)
    TYPE_TEXT = %w(txt rb js slim css scss coffee)

    use Rack::Deflater

    configure do
      disable :method_override
      disable :sessions

      set :views, File.expand_path('../app/views', __FILE__)
      set :markdown_renderer, WikiMD::Renderer.build
      set :public_folder, File.expand_path('../app/public', __FILE__)
    end

    # :nocov:
    configure :development do
      # settings for easier debugging
      Slim::Engine.set_options pretty: true, sort_attrs: false
      set :show_exceptions, :after_handler
    end
    # :nocov:

    helpers do
      def asset_path(name)
        url("assets/#{name}")
      end

      def octicon(name)
        %(<span class="octicon octicon-#{name}"></span>)
      end

      def tree_root
        repo.tree
      end

      def history_path(path)
        url('/h/' + path)
      end
    end

    not_found do
      slim :'404'
    end

    get '/search.json' do
      headers 'Content-Type' => 'application/json'
      files_set = FuzzySet.new(repo.files)
      files_set.get(params[:query]).to_json
    end

    get '/h/*' do |path|
      @path = path
      @history = repo.history(@path)
      slim :history
    end

    get '/*' do |path|
      @path = path
      @extension = (m = path.match(/(?:\.)([^.]+)$/)) ? m[1].downcase : ''
      begin
        @content = repo.read(@path, params[:at])
      rescue WikiMD::Repository::FileNotFound
        pass
      end
      slim :file
    end

    private

    def render_markdown(markdown)
      settings.markdown_renderer.render(markdown)
    end

    def repo
      @_repo ||= WikiMD::Repository.new(settings.repo_path)
    end
  end
end
