Application.class_eval do
  helpers do
    
    def css(name, media='screen projection')
      options = {
        :href => "/css/#{name}.css",
        :media => "#{media}",
        :rel => "stylesheet",
        :type => "text/css"
      }
      haml "%link#{options.inspect}"
    end
    
    def js(name)
      options = {
        :type => "text/javascript",
        :src => "/js/#{name}.js"
      }
      haml "%script#{options.inspect}"
    end
    
    def partial(name, options={})
      haml name, options.merge(:layout => false)
    end
  end
end
