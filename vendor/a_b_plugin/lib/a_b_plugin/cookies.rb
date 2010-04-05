class ABPlugin
  class Cookies
    class <<self
      
      def get(key)
        return unless ABPlugin.instance
      
        if ABPlugin.instance.respond_to?(:cookies)
          ABPlugin.instance.send(:cookies)[key.to_s]
        
        elsif ABPlugin.instance.respond_to?(:request)
          ABPlugin.instance.request.cookies[key.to_s]
      
        else
          $cookies ||= {}
          $cookies[key.to_s]
        end
      end
    
      def set(key, value)
        return unless ABPlugin.instance
      
        if ABPlugin.instance.respond_to?(:cookies)
          ABPlugin.instance.send(:cookies)[key.to_s] = value
        
        elsif ABPlugin.instance.respond_to?(:response)
          ABPlugin.instance.response.set_cookie(key.to_s, :value => value, :path => '/')
          ABPlugin.instance.request.cookies[key.to_s] = value
      
        else
          $cookies ||= {}
          $cookies[key.to_s] = value
        end
      
        true
      end
    end
  end
end