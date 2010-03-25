class ABPlugin
  module Cookies
    class <<self
      
      def get(type, test)
        return unless type && test
        
        type = type.to_s[0..0]
        
        Cookie.new[type][test['id'].to_s]
      end
      
      def set(type, test, variant, extra)
        return unless type && test && variant
        
        type = type.to_s[0..0]
        
        cookie = Cookie.new
        cookie[type][test['id'].to_s] = variant['id']
        if extra
          cookie['e'][variant['id'].to_s] ||= {}
          cookie['e'][variant['id'].to_s].merge!(extra)
        end
        cookie.sync unless cookie == Cookie.new
      end
    end
    
    class Cookie < Hash
      
      TYPES = %w(c v e)
      # conversions, visits, extras
      
      def initialize
        return unless ABPlugin.instance
        
        if ABPlugin.instance.respond_to?(:cookies)
          cookie = ABPlugin.instance.send(:cookies)[:a_b]
          
        elsif ABPlugin.instance.respond_to?(:request)
          cookie = ABPlugin.instance.request.cookies['a_b']
        
        else
          $cookies ||= {}
          cookie = $cookies['a_b']
        end
        
        self.replace(JSON cookie) if cookie
        
        TYPES.each do |type|
          self[type] ||= {}
        end
      end
      
      def sync
        return unless ABPlugin.instance
        
        # Tell javascript to send request
        self['s'] = 1
        
        TYPES.each do |type|
          self.delete(type) if self[type].empty?
        end
        
        if ABPlugin.instance.respond_to?(:cookies)
          ABPlugin.instance.send(:cookies)[:a_b] = self.to_json
          
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