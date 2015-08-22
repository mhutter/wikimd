require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module WikiMD
  # Renderer for converting Markdown to HTML
  # includes syntax highlighting from Rouge.
  class Renderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    # Builds a new renderer with all the capabilities we need.
    #
    # @return [Redcarpet::Markdown] a new Renderer.
    def self.build
      Redcarpet::Markdown.new self,
                              fenced_code_blocks: true,
                              no_intra_emphasis: true,
                              autolink: true,
                              strikethrough: true,
                              superscript: true,
                              highlight: true,
                              footnotes: true
    end

    # Generates CSS Rules required for syntax highlighting.
    #
    # @return [String] CSS!
    def self.css
      Rouge::Themes::Github.render(scope: '.highlight')
    end
  end
end
