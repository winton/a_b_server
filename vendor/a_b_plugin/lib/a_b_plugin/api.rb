class ABPlugin
  class API
    
    include HTTParty
    
    def self.create_category(attributes)
      return unless Config.token && Config.url
      base_uri Config.url
      post('/categories/create.json', :query => compress(
        :token => attributes.delete(:token) || Config.token,
        :category => attributes
      ))
    end
    
    def self.create_env(attributes)
      return unless Config.token && Config.url
      base_uri Config.url
      post('/envs/create.json', :query => compress(
        :token => attributes.delete(:token) || Config.token,
        :env => attributes
      ))
    end
    
    def self.create_site(attributes)
      return unless Config.token && Config.url
      base_uri Config.url
      post('/sites/create.json', :query => compress(
        :token => attributes.delete(:token) || Config.token,
        :site => attributes
      ))
    end
    
    def self.create_user(attributes)
      return unless Config.token && Config.url
      base_uri Config.url
      post('/users/create.json', :query => compress(
        :token => attributes.delete(:token) || Config.token,
        :user => attributes
      ))
    end
    
    def self.site(options={})
      return unless Config.token && Config.url && (options[:name] || Config.site)
      base_uri Config.url
      get('/site.json', :query => compress(
        :include => options[:include],
        :name => options[:name] || Config.site,
        :only => options[:only],
        :token => Config.token
      ))
    end
    
    def self.sites(options={})
      return unless Config.token && Config.url
      base_uri Config.url
      get('/sites.json', :query => compress(
        :include => options[:include],
        :only => options[:only],
        :token => options[:token] || Config.token
      ))
    end
    
    private
    
    def self.compress(hash)
      hash.delete_if { |key, value| value.nil? }
    end
  end
end