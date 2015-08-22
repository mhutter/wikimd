# Hello World

It works!

intra_emphasis_sucks!

Let's https://www.google.com it!

this is ~~bad~~ good

this is the 2^(nd) time, but this[^1] is a footnote.

[^1]: really!

This is a "quote" indeed!

and this is ==highlighted== as hell!

oh and what about `inline` code?


```ruby
require 'bundler/setup'
Bundler.require(:default)

REPO = File.expand_path('../repo', __FILE__)

get '/:path' do
  path = File.join(REPO, params[:path])
  pass unless File.exists?(path)

  md = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
  md.render(open(path).read)
end
```
