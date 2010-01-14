module ABPlugin
  module Adapters
    module Sinatra
    
      def self.included(klass)
        klass.send :before do
          session[:a_b_id] ||= ABPlugin.generate_token
          ABPlugin.session_id = session[:a_b_id]
          ABPlugin.session = session
          if ABPlugin.session
            @a_b_selections = ABPlugin.session[:a_b]
          end
          ABPlugin.reload if ABPlugin.reload?
        end
      end
    end
  end
end

Sinatra::Base.send(:include, ABPlugin::Adapters::Sinatra)
Sinatra::Base.send(:include, ABPlugin::Helper)