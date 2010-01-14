module ABPlugin
  class API
    include HTTParty
    
    def self.boot(token, url)
      base_uri url
      self.get('/boot.json', :query => { :token => token })
    end
  end
end