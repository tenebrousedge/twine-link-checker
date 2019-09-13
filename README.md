# TwineLinkChecker

This gem is an extremely simplistic tool to find broken links in twine projects. It will probably work just fine with any text file containing relative paths. It will not handle absolute paths correctly, nor does it support all allowable characters in filenames.

The currently supported file extensions are: jpg jpeg webm png gif
Expect erroneous results if the path or filename contain those strings (other than at the end).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twine_link_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twine_link_checker

## Usage

    $ twine_link_checker missing path/to/your/html/file

"missing" is the only command, it should produce the relative paths of any missing files.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tenebrousedge/twine_link_checker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TwineLinkChecker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/twine_link_checker/blob/master/CODE_OF_CONDUCT.md).
