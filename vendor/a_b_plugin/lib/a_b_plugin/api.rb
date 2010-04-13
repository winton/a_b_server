class ABPlugin
  class API
    
    include HTTParty
    
    def self.categories
      return unless Config.url && Config.token
      base_uri Config.url
      get('/categories.json', :query => { :token => Config.token })
    end
  end
end