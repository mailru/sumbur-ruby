module Sumbur
  module PureRuby
    extend self

    def sumbur(hashed_integer, cluster_capacity)
      raise ArgumentError, "Sumbur is not applicable to empty cluster"    if cluster_capacity == 0
      raise ArgumentError, "Sumbur accepts only positive 32bit integers"  if hashed_integer < 0 || hashed_integer > 0xFFFFFFFF

      l = 0xFFFFFFFF
      part = l / cluster_capacity

      return 0  if l - hashed_integer <= part

      h = hashed_integer
      n = 1
      i = 2
      while i <= cluster_capacity
        c = l / (i * (i-1))
        if c <= h
          h -= c
        else
          h += c * (i-n-1)
          n = i
          break if l / n - h < part
        end
        i += 1
      end
      n - 1
    end
  end
end
