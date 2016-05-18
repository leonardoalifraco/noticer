[![Build Status](https://travis-ci.org/leonardoalifraco/noticer.svg?branch=master)](https://travis-ci.org/leonardoalifraco/noticer)
[![Code Climate](https://codeclimate.com/github/leonardoalifraco/noticer/badges/gpa.svg)](https://codeclimate.com/github/leonardoalifraco/noticer)

# Noticer

Noticer is a gem that allows the emission of notifications using a topic routing algorithm.

Configure the routing patterns along with a callback which is executed when the notification routing key matches the pattern.

It's useful when you want to abstract your application from different notification providers, or when the notification providers does not have message routing features (ie: AWS SNS).

Routing patterns allow the following wildcards:

```
* (star) can substitute for exactly one word.
# (hash) can substitute for zero or more words.
```

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'noticer'
```

Then run:

``` shell
bundle install
```

## Usage

First configure the routing patterns along with the callbacks.

``` ruby
Noticer.configure do |config|
  config.notification_routes = [
    {
      routing_patterns: ['tree.green', 'tree.red'],
      callback: -> (routing_key, message) {
        # notify by email
      }
    },
    {
      routing_patterns: ['tree.*'],
      callback: -> (routing_key, message) {
        # notify to log
      }
    }
  ]
end
```

Then emit the required messages.

``` ruby
# This will dispatch both notification callbacks
Noticer.emit('tree.green', 'A green tree was planted.')


# This will dispatch only the log callback
Noticer.emit('tree.blue', 'A blue tree was planted.')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leonardoalifraco/noticer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
