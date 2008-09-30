module Waves
  module Caches

    module Memcached 
      require 'memcached' and Waves.config.dependencies << 'memcached'
     #  Only un-comment if you understand the implications.
#       require 'memcached-ext'
#	include Waves::Cache::Memcached::Extensions
      class << self

        def new(args)
          # initialize takes what you would throw at Memcached.new

          raise ArgumentError, "need :servers to not be nil" if args[:servers].nil?
          args[:opt] = args.has_key?(:opt) ? args[:opt] : {}
          @cache = ::Memcached.new(args[:servers], args[:opt])
        end

        def store(key,value, ttl = 0, marshal = true)
          Waves.synchronize { cache = @cache.clone;  cache.add(key.to_s,value,ttl,marshal);  cache.destroy }
        end

        def fetch(key)
          Waves.synchronize { cache = @cache.clone;  cache.get(key.to_s);  cache.destroy }
        rescue ::Memcached::NotFound
          nil
        end

        def delete(*keys)
          keys.each {|key| Waves.synchronize { cache = @cache.clone; cache.delete(key.to_s) };  cache.destroy }
        rescue ::Memcached::NotFound
          nil
        end

        def clear
          Waves.synchronize { cache = @cache.clone;  cache.flush;  cache.destroy }
        end

      end
    end

  end
end
