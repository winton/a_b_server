class ABPlugin
  module Config
    class <<self
      
      def binary(binary=nil)
        @binary = binary unless binary.nil?
        @binary
      end
      
      def env(env=nil)
        @env = env unless env.nil?
        @env || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      end
      
      def reset
        @binary = @env = @root = @site = @url = @token = @yaml = nil
      end
      
      def root(root=nil)
        @root = root unless root.nil?
        @root
      end
      
      def site(site=nil)
        @site = site unless site.nil?
        @site
      end
      
      def url(url=nil)
        @url = url unless url.nil?
        @url
      end
      
      def token(token=nil)
        @token = token unless token.nil?
        @token
      end
      
      def yaml(yaml=nil)
        @yaml = yaml unless yaml.nil?
        @yaml || ("#{root}/config/a_b.yml" if root)
      end
    end
  end
end