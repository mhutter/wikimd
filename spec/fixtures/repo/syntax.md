# Hello World

It works!

intra_emphasis_sucks, but _normal_ em's are **A OK**!

Let's https://www.google.com it!

this is ~~bad~~ good

this is the 2^(nd) time, but this[^1] is a footnote. <sub>sadface</sub>

[^1]: really!

This is a "quote" indeed!

and this is ==highlighted== as hell!

oh and what about `inline` code?

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


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
