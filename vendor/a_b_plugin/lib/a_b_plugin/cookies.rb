class ABPlugin
  module Cookies
    class <<self
      
      def get(type, test)
        return unless type && test
        
        type = type.to_s[0..0]
        
        Cookie.new[type][test['id'].to_s]
      end
      
      def set(type, test, variant)
        return unless type && test && variant
        
        type = type.to_s[0..0]
        
        cookie = Cookie.new
        cookie[type][test['id'].to_s] = variant['id']
        cookie.sync
      end
      
      class Cookie < Hash
        
        def initialize
          return unless ABPlugin.instance
          
          if ABPlugin.instance.respond_to?(:cookies)
            cookie = ABPlugin.instance.cookies[:a_b]
            
          elsif ABPlugin.instance.respond_to?(:request)
            cookie = ABPlugin.instance.request.cookies['a_b']
          
          else
            $cookies ||= {}
            cookie = $cookies['a_b']
          end
          
          self.replace(JSON cookie) if cookie
          
          self['c'] ||= {}
          self['v'] ||= {}
        end
        
        def sync
          return unless ABPlugin.instance
          
          if ABPlugin.instance.respond_to?(:cookies)
            ABPlugin.instance.cookies[:a_b] = self.to_json
            
          elsif ABPlugin.instance.respond_to?(:response)
            ABPlugin.instance.response.set_cookie('a_b', :value => self.to_json, :path => '/')
            ABPlugin.instance.request.cookies['a_b'] = self.to_json
          
          else
            $cookies ||= {}
            $cookies['a_b'] = self.to_json
          end
          
          true
        end
      end
    end
  end
end