class ABPlugin
  module Adapters
    module Sinatra
      
      def self.included(klass)
        ABPlugin do
          env klass.environment
          root klass.root
        end
      end
    end
  end
end

Sinatra::Base.send(:include, ABPlugin::Helper)