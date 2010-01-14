module ABPlugin
  module Adapters
    module Rails
    
      def self.included(klass)
        if defined?(::ApplicationController)
          raise 'Please require a_b_plugin before all other plugins.'
        end
        klass.prepend_before_filter :a_b_plugin_before_filter
      end
    
      private
      
      def a_b_plugin_before_filter
        session_id = session[:session_id][0..9] rescue nil
        ABPlugin.session_id = session_id
        ABPlugin.session = session
        if ABPlugin.session
          @a_b_selections = ABPlugin.session[:a_b]
        end
        ABPlugin.reload if ABPlugin.reload?
      end
    end
  end
end

ActionController::Base.send(:include, ABPlugin::Adapters::Rails)
ActionController::Base.send(:include, ABPlugin::Helper)
ActionController::Base.helper(ABPlugin::Helper)