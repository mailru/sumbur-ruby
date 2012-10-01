# Sumbur

It is an implementation of Sumbur consistent spreading algorithm authored by Maksim Kalinchenko uint32@mail.ru

Here is an explanation of algorithm as far as I could understand it:

    Initially we have 1 server (#0) and 72 items:
    0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
    
    Then we add second server (#1),
    so that we move 72 / 1 - 72 / 2 = 36 items from first to second server :
    1111 1111 1111 1111 1111 1111 1111 1111 1111 0000 0000 0000 0000 0000 0000 0000 0000 0000

    Then we add third server (#2),
    and we move 72 / 2 - 72 / 3 = 72 / (2 * 3) = 12 items from each server to third :
    2222 2222 2222 1111 1111 1111 1111 1111 1111 2222 2222 2222 0000 0000 0000 0000 0000 0000

    forth server (#3), 72 / (3 * 4) = 6 items from each server to forth:
    3333 3322 2222 3333 3311 1111 1111 1111 1111 2222 2222 2222 3333 3300 0000 0000 0000 0000
    
    Algorithm operates on 2**32 items space, and you ought to map your values with good hashing function
    into that space (with good avalance of high bits). But when such mapping is provided, Sumbur
    guarantees that values are sufficiently uniformly spreaded across the servers, and when new servers
    are added, values are moved only from old servers to new in a sufficiently equal amounts.

It seems like component of kind of consistent hashing, but:
a) it doesn't lock hash function (you should provide it),
b) it doesn't provide tools to handle falling of random server.

b) - is the reason, why I avoid to call it "consistent hashing". It is more like a way to handle
spreading/sharding items across increasing number of shards/servers in an environment, where you
handle replication and failover by your self. It is mostly used in an environment, where database
servers are organized in a kind of RAID0+1: items are spread over number of shards, each shard is
protected by replication. While "consistent hashing" mostly assumes, that items are replicated over
number of shards.

Closest analog I've seen so far is Guava Google Library's [consistentHash function](http://code.google.com/p/guava-libraries/source/browse/guava/src/com/google/common/hash/Hashing.java?name=release12#197).
It has some benefit cause it randomize input integer, so that doesn't require separate hash function.
Also it is a bit faster with huge number of shards. But in most cases Sumbur gives slightly better
spreading.

## Installation

Add this line to your application's Gemfile:

    gem 'sumbur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sumbur

## Usage
Strict dependency: you ought to provide 32bit unsigned hash function with good spreading of high bits.
For example, you could use `Zlib.crc32` or [MurmurHash3](https://github.com/funny-falcon/murmurhash3-ruby).

```ruby
  require 'sumbur'

  servers = [server0, server1, server2]
  server_nom = Sumbur.sumbur(unsigned_32bit_hashof(value), servers.size) # => 0 <= int < servers.size
  use servers[server_nom]

  class Class
    include Sumbur
    def method
      servers[ sumbur(unsigned_32bit_hashof(value), servers.size) ]
    end
  end
```

In case of monotonically increasing integer keys (record id) following function could be used as hash given
unbeatably good spreading with sumbur:

```ruby
  def unsigned_32bit_hashof(id)
    h = id * 0x531a5229 & 0xffffffff
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
