
module Waves

  module Caches

    # Looks barebones in here, huh?
    # That's because the Waves::Cache API is implemented in a separate file.
    require 'cache/cache-class'

    def self.new
      Waves::Caches::Hash.new
    end

  end
end