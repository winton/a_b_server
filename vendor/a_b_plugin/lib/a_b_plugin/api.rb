class ABPlugin
  class API
    
    include HTTParty
    
    def self.boot
      return unless Config.url && Config.token
      base_uri Config.url
      get('/tests.json', :query => { :token => Config.token })
    end
  end
end