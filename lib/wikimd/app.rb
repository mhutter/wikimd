require 'bundler/setup'

require 'sinatra/base'
require 'slim'
require 'puma'

require 'wikimd/renderer'
require 'wikimd/repository'

module WikiMD
  # Main Sinatra application
  class App < Sinatra::Base
    configure do
      set :views, File.expand_path('../app/views', __FILE__)
      set :markdown_renderer, WikiMD::Renderer.build
    end

    configure :development do
      # settings for easier debugging
      Slim::Engine.set_options pretty: true, sort_attrs: false
    end

    get '/favicon.ico' do
      ''
    end

    get '/' do
      slim "pre Hello! The repo is at '#{settings.repo}'"
    end

    get '/*' do |path|
      begin
        @content = render_markdown(repo.read(path))
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
      @_repo ||= WikiMD::Repository.new(settings.repo)
    end
  end
end
