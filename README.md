# Sumbur

It is an implementation of Sumbur spreading algorithm authored by Maksim Kalinchenko uint32@mail.ru

## Installation

Add this line to your application's Gemfile:

    gem 'sumbur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sumbur

## Usage

```ruby
  require 'sumbur'

  servers = [server0, server1, server2]
  server_nom = Sumbur.sumbur(hashof(value), servers.size) # => 0 <= int < servers.size
  use servers[server_nom]

  class Class
    include Sumbur
    def method
      servers[ sumbur(hashof(value), servers.size) ]
    end
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
