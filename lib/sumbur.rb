require "sumbur/version"

module Sumbur
  begin
    require 'sumbur/native_sumbur'
    include NativeSumbur
    extend NativeSumbur
  rescue LoadError
    require 'sumbur/pure_ruby'
    include PureRuby
    extend PureRuby
  end
end
