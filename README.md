# Identiconify

Identiconify makes it super simple to generate identicons representing string
values such as usernames or ip addresses.

## Installation

Add this line to your application's Gemfile:

    gem 'identiconify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install identiconify

## Usage

Require the Identiconify

```ruby
require 'identiconify'
```

Now you have access to the Identiconify::Identicon class which can be use as
such:

```ruby
string = "this is my string"
identicon = Identiconify::Identicon.new(string)
png_data = identicon.to_png_blob

# The png data can then be written to disk or be sent over an http connection
File.open('image.png', 'w') do |file|
  file.write(png_data)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
