module Waves
  module Cache

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

      def [](key)
        fetch key
      end

      def []=(key,value)
        store key, value
      end

      def store(key,value, ttl = 0, marshal = true)
        Waves.synchronize { cache = @cache.clone;  cache.add(key.to_s,value,ttl,marshal)  }
      end

      def fetch(key)
        Waves.synchronize { cache = @cache.clone;  cache.get(key.to_s) }
      rescue ::Memcached::NotFound => e
        # In order to keep the Memcached layer compliant with Waves::Cache...
        # ...we need to be able to expect that an absent key raises KeyMissing
        raise KeyMissing, "#{key} doesn't exist, #{e}"
      end

      def delete(*keys)
        keys.each {|key| Waves.synchronize { cache = @cache.clone; cache.delete(key.to_s) };  cache.destroy }
      end

      def clear
        Waves.synchronize { cache = @cache.clone;  cache.flush;  cache.destroy }
      end

    end
    end

  end
end
