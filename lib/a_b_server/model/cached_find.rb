require 'pp'

module CachedFind
  
  def cached_find(*args)
    $cached_find ||= {}
    cache = $cached_find[self.to_s.intern] ||= {}
    cache[args.pretty_inspect] ||= self.find(*args)
  end
end