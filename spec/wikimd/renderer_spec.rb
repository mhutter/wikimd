require 'wikimd/renderer'

RSpec.describe WikiMD::Renderer do
  let(:r) { WikiMD::Renderer.build }
  describe '#build' do
    it 'returns an instance of Redcarpet::Markdown' do
      expect(WikiMD::Renderer.build).to be_a(Redcarpet::Markdown)
    end
  end

  describe '#render' do
    it 'renders markdown as HTML' do
      expect(r.render('# Hello, World')).to eq "<h1>Hello, World</h1>\n"
    end

    # Make sure our expectations of a markdown renderer are met.

    it "doesn't render intra-emphasis" do
      expect(r.render('a_b_c')).to_not match(%r{<(em|i)/?>})
    end

    it 'autolinks URLs' do
      expect(r.render('http://example.com'))
        .to include('<a href="http://example.com">http://example.com</a>')
    end

    it 'renders fenced code blocks' do
      doc = <<-EOT
```ruby
puts "foo"
```
      EOT
      result = r.render(doc)
      expect(result).to_not include('<code>ruby')
      expect(result).to include('<pre class="highlight ruby">')
    end

    it 'renders strikethrough' do
      expect(r.render('~~bad~~')).to include('<del>bad</del>')
    end

    it 'renders footnotes' do
      doc = <<-EOT
this[^1] is a footnote.

[^1]: really!
      EOT
      result = r.render(doc)
      %w(fnref1 #fn1 fn1 footnote).each do |word|
        expect(result).to include word
      end
    end

    it 'renders superscript' do
      expect(r.render('1^(st)')).to include '1<sup>st</sup>'
    end

    it 'renders highlights' do
      expect(r.render('==high==')).to include '<mark>high</mark>'
    end
  end #render

  describe '.css' do
    it 'returns some Rouge CSS' do
      expect(WikiMD::Renderer.css).to include('.highlight {')
    end
  end #css
end
