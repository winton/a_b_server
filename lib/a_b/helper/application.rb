Application.class_eval do
  helpers do
    
    # Assets
    
    def css(name, media='screen, projection')
      options = {
        :href => "/css/#{name}.css",
        :media => "#{media}",
        :rel => "stylesheet",
        :type => "text/css"
      }
      haml "%link#{options.inspect}", :layout => false
    end
    
    def javascripts(&block)
      (@js || []).each do |path|
        block.call path
      end
    end
    
    def js(name)
      options = {
        :type => "text/javascript",
        :src => "/js/#{name}.js"
      }
      haml "%script#{options.inspect}", :layout => false
    end
    
    def partial(name, options={})
      haml name, options.merge(:layout => false)
    end
    
    def stylesheets(&block)
      (@css || []).each do |path|
        block.call path
      end
    end
    
    # Authentication
    
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def restrict
      redirect '/sessions/new' unless current_user
    end
  end
end
