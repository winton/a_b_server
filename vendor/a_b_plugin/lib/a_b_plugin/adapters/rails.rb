class ABPlugin
  module Adapters
    module Rails
    
      def self.included(klass)
        ABPlugin do
          env ::Rails.env
          root ::Rails.root
        end
      end
    end
  end
end

ActionController::Base.send(:include, ABPlugin::Adapters::Rails)
ActionController::Base.send(:include, ABPlugin::Helper)
ActionController::Base.helper(ABPlugin::Helper)