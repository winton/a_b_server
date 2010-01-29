module ABPlugin
  module Adapters
    module Rails
    
      def self.included(klass)
        if defined?(::ApplicationController)
          raise 'Please require a_b_plugin before all other plugins.'
        end
        klass.before_filter :a_b_plugin_before_filter
      end
    
      private
      
      def a_b_plugin_before_filter
        id = session[:a_b_id]
        unless id
          id = session[:a_b_id] = ABPlugin.generate_token
        end
        ABPlugin.session_id = id
        ABPlugin.session = session
        @a_b_selections = ABPlugin.session[:a_b]
        ABPlugin.reload if ABPlugin.reload?
      end
    end
  end
end

ActionController::Base.send(:include, ABPlugin::Adapters::Rails)
ActionController::Base.send(:include, ABPlugin::Helper)
ActionController::Base.helper(ABPlugin::Helper)