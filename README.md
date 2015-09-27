# WikiMD

Turn any Git-repository into a Wiki!

## State

This Project is currently under development. It works, but there are some rough edges!

## Installation & Usage

```bash
# Install WikiMD
$ gem install wikimd

# browse to your Git-repo and run wikimd
$ cd my/git/repo
$ wikimd
Thin web server (v1.6.4 codename Gob Bluth)
Maximum connections set to 1024
Listening on 0.0.0.0:8777, CTRL+C to stop
```

That's all! Now browse to http://localhost:8777 and view your Repository!

## Development

After checkout, run `script/setup` to install dependencies. Run `bundle exec rspec` to run unit tests, or `bundle exec cucumber` to run feature specs.

If you make changes to the SCSS files, run `script/build` to regenerate the CSS files.

To automatically rebuild CSS, run

    bundle exec scss --sourcemap=none --watch _scss/wikimd.scss:lib/wikimd/app/public/assets/css/wikimd.css`

However, still run `script/build` before commiting if you changed any SCSS files!

To install this gem onto your local machine, run `bundle exec rake install`.


## Contributing

Fork it ( https://github.com/mhutter/string-similarity/fork )
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin my-new-feature)
Create a new Pull Request
Bug reports and pull requests are welcome on GitHub at https://github.com/mhutter/string-similarity.

License

The gem is available as open source under the terms of the MIT License.


## Contributing

1. Fork it ( https://github.com/mhutter/wikimd/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/mhutter/wikimd.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
