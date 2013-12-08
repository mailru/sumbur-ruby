# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sumbur/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sokolov Yura 'funny-falcon'", "Maksim Kalinchenko"]
  gem.email         = ["funny.falcon@gmail.com", "uint32@mail.ru"]
  gem.description   = %q{Sumbur - consistent spreading for server balancing}
  gem.summary       = %q{Sumbur - consistent spreading for server balancing}
  gem.homepage      = "https://github.com/mailru/sumbur-ruby"
  gem.license       = "MIT"

  if RUBY_ENGINE == 'ruby'
    gem.extensions    = ["ext/sumbur/extconf.rb"]
    gem.require_paths = ["lib", "ext"]
    gem.files         = Dir['ext/**/*'].grep(/\.(rb|c)$/) +
                      (Dir['lib/**/*'] + Dir['test/**/*']).grep(/\.rb$/)
  elsif RUBY_ENGINE == 'jruby'
    gem.files         = (Dir['lib/**/*'] + Dir['test/**/*']).grep(/\.(rb|jar)$/)
    gem.platform = 'jruby'
    gem.require_paths = ["lib"]
  end
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.name          = "sumbur"
  gem.version       = Sumbur::VERSION
end
