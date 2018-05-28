# InvalidUtf8Rejector

[![CircleCI](https://circleci.com/gh/alext/invalid_utf8_rejector.svg?style=shield)](https://circleci.com/gh/alext/invalid_utf8_rejector)

Simple Rack middleware that rejects requests containing invalid UTF-8 byte
sequences in their path or query params.

## Installation

Add this line to your application's Gemfile:

    gem 'invalid_utf8_rejector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invalid_utf8_rejector

## Usage

If you are using Rails, the middleware will automatically be inserted. If not,
you will need to manually insert it into your middleware stack.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
