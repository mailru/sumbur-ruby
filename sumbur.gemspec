# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sumbur/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sokolov Yura 'funny-falcon'", "Maksim Kalinchenko"]
  gem.email         = ["funny.falcon@gmail.com", "uint32@mail.ru"]
  gem.description   = %q{Sumbur - consistent spreading}
  gem.summary       = %q{Sumbur - consistent spreading}
  gem.homepage      = "https://github.com/mailru/sumbur-ruby"

  gem.files         = Dir['ext/**/*'].grep(/\.(rb|c)$/) +
                      (Dir['lib/**/*'] + Dir['test/**/*']).grep(/\.rb$/)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.extensions    = ["ext/sumbur/extconf.rb"]
  gem.name          = "sumbur"
  gem.require_paths = ["lib", "ext"]
  gem.version       = Sumbur::VERSION
end
