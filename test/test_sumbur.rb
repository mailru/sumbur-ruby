require 'minitest/spec'
require 'minitest/autorun'

$spread_cache = {}

HASHED = (1..1_000_000).map{|i| [i.hash & 0xFFFFFFFF, i]}

def spread(num, capa, sumbur)
  start = Time.now
  v = $spread_cache[ [num, capa, sumbur] ] ||= HASHED[0, num].
      map{|hash, int| [sumbur.sumbur(hash, capa), int]}.
      group_by{|serv, int| serv}
  d = Time.now - start
  puts format("%s %.4f", [num, capa, sumbur].inspect, d)  if d > 0.01
  v
end

shared_example = proc do
  it "should spread capacity" do
    for num in [100_000, 1_000_000]
      for capa in [2,3,7,8,17,18]
        spread(num, capa, sumbur).each{|serv, ints|
          ints.size.must_be_within_epsilon num/capa, 7000.0/num
        }
      end
    end
  end

  it "should reshard values cleanly" do
    for num in [100_000, 1_000_000]
      for capa in [2,3,7,8,17,18]
        cur = spread(num, capa, sumbur)
        nxt = spread(num, capa+1, sumbur)
        moved = 0
        for i in 0...capa
          (nxt[i] - cur[i]).must_be_empty
          moved += mvd = (cur[i] - nxt[i]).size
          mvd.must_be_within_epsilon (num/capa - num/(capa+1)), 40000.0/num
        end
        moved.must_be_within_epsilon num/(capa+1), 7000.0/num
      end
    end
  end
end

require 'sumbur/pure_ruby'
describe "Pure Ruby" do
  let(:sumbur){ Sumbur::PureRuby }
  class_exec &shared_example
end

begin
  require 'sumbur/native_sumbur'

  describe "Native" do
    let(:sumbur) { Sumbur::Native }
    class_exec &shared_example

    it "should produce same spread as pure ruby version" do
      for capa in [2,3,4,7,8,9,17,18,19]
        spread(1_000_000, capa, Sumbur::Native).must_equal spread(1_000_000, capa, Sumbur::PureRuby)
      end
    end
  end
rescue LoadError
  puts "Native version is not tested"
end
