module Waves
  module Cache

   module Memcached
     module Extensions  

       def method_missing(*args, &block)
         @cached.__send__(*args, &block)
       rescue => e
         Waves::Logger.error e.to_s
         nil
       end

     end
   end

  end
end
