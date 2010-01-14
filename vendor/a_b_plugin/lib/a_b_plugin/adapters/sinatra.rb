module ABPlugin
  module Adapters
    module Sinatra
    
      def self.included(klass)
        klass.send :before do
          session_id = env["rack.request.cookie_hash"]["rack.session"][0..19] rescue nil
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
end

Sinatra::Base.send(:include, ABPlugin::Adapters::Sinatra)
Sinatra::Base.send(:include, ABPlugin::Helper)