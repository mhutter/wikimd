require 'json'

require 'bundler/setup'
require 'sinatra/base'
require 'fuzzy_set'
require 'slim'
require 'puma'

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

      def js_files
        repo.files.to_json.gsub('/', ',')
      end
    end

    # get '/' do
    #   slim "p Hello, World!\n" * 100
    # end

    get '/search.json' do
      headers 'Content-Type' => 'application/json'
      files_set = FuzzySet.new(repo.files)
      files_set.get(params[:query]).to_json
    end

    get(%r{/(.*)/history$}) do |path|
      @path = path
      begin
        @history = repo.history(@path)
      rescue WikiMD::Repository::FileNotFound
        pass
      end
      slim :history
    end


    get(%r{/(.*[^/])$}) do |path|
      @path = path
      @extension = (m = path.match(/(?:\.)([^.]+)$/)) ? m[1].downcase : ''
      begin
        @content = repo.read(@path, params[:at])
      rescue WikiMD::Repository::FileNotFound
        pass
      end

      slim :file
    end

    get(%r{/(.*)/?}) do |path|
      pass unless repo.dir?(path)
      @tree = repo.tree(path)
      slim :folder
    end

    private

    def render_markdown(markdown)
      settings.markdown_renderer.render(markdown)
    end

    def repo
      @_repo ||= WikiMD::Repository.new(settings.repo)
    end
  end
end
