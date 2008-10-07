module Waves
  module Layers
    module Cache

      module File
        
        def self.included(app)
          require 'layers/cache/file/file-class'

          if Waves.cache.nil?
            Waves.cache = Waves::Caches::File.new( Waves.config.cache )
          end
          
        end
      end

    end
  end
end

