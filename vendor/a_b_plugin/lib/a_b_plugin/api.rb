class ABPlugin
  class API
    
    include HTTParty
    
    def self.categories
      return unless Config.site && Config.token && Config.url
      base_uri Config.url
      get('/categories.json', :query => {
        :site => Config.site,
        :token => Config.token
      })
    end
  end
end