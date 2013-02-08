# Facwparser

Fuxxing Atlassian Confluence Wiki Parser

This is a loose Atlassian Confluence Wiki parser.

## Installation

Add this line to your application's Gemfile:

    gem 'facwparser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install facwparser

## Usage

```ruby
require 'facwparser'
print <<EOS
<!DOCTYPE html>
<html>
<head>
<title>sample</title>
</head>
<body>
EOS
print Facwparser.to_html(ARGF.read)
print <<EOS
</body>
</html>
EOS
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
