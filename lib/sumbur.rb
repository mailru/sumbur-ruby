require "sumbur/version"

module Sumbur
  begin
    require 'sumbur/native_sumbur'
    include Native
    extend Native
  rescue LoadError
    require 'sumbur/pure_ruby'
    include PureRuby
    extend PureRuby
  end
end
