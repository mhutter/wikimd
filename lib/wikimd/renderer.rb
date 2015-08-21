require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module WikiMD
  # Renderer for converting Markdown to HTML
  # includes syntax highlighting from Rouge.
  class Renderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def self.build
      Redcarpet::Markdown.new Renderer,
                              fenced_code_blocks: true,
                              no_intra_emphasis: true,
                              autolink: true,
                              superscript: true,
                              highlight: true,
                              footnotes: true
    end
  end
end
