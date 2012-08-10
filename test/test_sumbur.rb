require 'minitest/spec'
require 'minitest/autorun'

$spread_cache = {}

HASHED = (1..1_000_000).map{|i|
  h = i ^ (i >> 16)
  h = (h * 0x85ebca6b) & 0xFFffFFff
  h ^= h >> 13
  h = (h * 0xc2b2ae35) & 0xFFffFFff
  [h ^ (h >> 16), i]
}

def spread(num, capa, sumbur)
  start = Time.now
  #v = $spread_cache[ [num, capa, sumbur] ] ||=
  v = HASHED[0, num].
      map{|hash, int| [sumbur.sumbur(hash, capa), int]}.
      group_by{|serv, int| serv}
  d = Time.now - start
  puts format("%s %.4f", [num, capa, sumbur].inspect, d)  if d > 0.01
  v
end

shared_example = proc do
  it "should spread capacity" do
    for num, eps in [[100_000, 0.05], [1_000_000, 0.011]]
      for capa in [2,3,7,8,17,18]
        spread(num, capa, sumbur).each{|serv, ints|
          ints.size.must_be_within_epsilon num/capa, eps
        }
      end
    end
  end

  it "should reshard values cleanly" do
    for num, eps in [[100_000, 0.2], [1_000_000, 0.05]]
      for capa in [2,3,7,8,17,18]
        cur = spread(num, capa, sumbur)
        nxt = spread(num, capa+1, sumbur)
        moved = 0
        for i in 0...capa
          (nxt[i] - cur[i]).must_be_empty
          moved += mvd = (cur[i] - nxt[i]).size
          mvd.must_be_within_epsilon (num/capa - num/(capa+1)), eps
        end
        moved.must_be_within_epsilon num/(capa+1), eps
      end
    end
  end
end

require 'sumbur/pure_ruby'
describe "Pure Ruby" do
  def sumbur
    Sumbur::PureRuby
  end
  class_exec &shared_example
end

begin
  if RUBY_ENGINE == 'jruby'
    require 'sumbur/sumbur.jar'
  else
    require 'sumbur/native_sumbur'
  end

  describe "Native" do
    def sumbur
      if RUBY_ENGINE == 'jruby'
        Sumbur::Java
      else
        Sumbur::NativeSumbur
      end
    end
    class_exec &shared_example

    it "should produce same spread as pure ruby version" do
      for capa in [2,3,4,7,8,9,17,18,19]
        spread(1_000_000, capa, sumbur).must_equal spread(1_000_000, capa, Sumbur::PureRuby)
      end
    end
  end
rescue LoadError
  puts "Native version is not tested"
end
