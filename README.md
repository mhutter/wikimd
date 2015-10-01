# WikiMD
[![Gem Version](https://badge.fury.io/rb/wikimd.svg)](http://badge.fury.io/rb/wikimd)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://rubydoc.org/gems/wikimd/frames)
[![Build Status](https://travis-ci.org/mhutter/wikimd.svg)](https://travis-ci.org/mhutter/wikimd)
[![Code Climate](https://codeclimate.com/github/mhutter/wikimd/badges/gpa.svg)](https://codeclimate.com/github/mhutter/wikimd)
[![Test Coverage](https://codeclimate.com/github/mhutter/wikimd/badges/coverage.svg)](https://codeclimate.com/github/mhutter/wikimd/coverage)


Turn any Git-repository into a Wiki!

## Installation & Usage

```bash
# Install WikiMD
$ gem install wikimd

# browse to your Git-repo and run wikimd
$ cd my/git/repo
$ wikimd
[2015-10-01 02:20:32] INFO  WEBrick 1.3.1
[2015-10-01 02:20:32] INFO  ruby 2.2.3 (2015-08-18) [x86_64-darwin14]
[2015-10-01 02:20:32] INFO  WEBrick::HTTPServer#start: pid=48477 port=8777
# WikiMD will automatically pick up "thin" or similar if installed
```

That's all! Now browse to [localhost:8777](http://localhost:8777) and browse your repository!

## Development

After checkout, run `script/setup` to install dependencies. Run `bundle exec rspec` to run unit tests, or `bundle exec cucumber` to run feature specs.

If you make changes to the SCSS files, run `script/build` to regenerate the CSS files.

To automatically rebuild CSS, run

    bundle exec scss --sourcemap=none --watch _scss/wikimd.scss:lib/wikimd/app/public/assets/css/wikimd.css

However, still run `script/build` before committing if you changed any SCSS files!

To install this gem onto your local machine, run `bundle exec rake install`.


## Contributing

1. Fork it ( https://github.com/mhutter/wikimd/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/mhutter/wikimd.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
