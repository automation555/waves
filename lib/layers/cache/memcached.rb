#--
# Waves::Layers::Cache::Memcached
# File: lib/layers/cache/memcached.rb
#++
# Framework layer to access your memcached server(s). The specific gem we use is 'memcached'.
# If you want to forward missing methods to the memcached object include Waves::Layers::Cache::Memcached::Ext .

module Waves
  module Layers
    module Cache

      module Memcached
        
        def self.included(app)
          require 'layers/cache/memcached/memcached-module'
          include Waves::Cache::Memcached          

          if Waves.cache.nil?
            Waves.cache = Waves::Cache::Memcached
            Waves.cache.new( Waves.config.cache )
          end
          
        end

      end
    end
  end
end
