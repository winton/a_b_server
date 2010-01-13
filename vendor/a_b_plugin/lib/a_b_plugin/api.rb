require 'rubygems'
gem 'httparty', '=0.5.0'
require 'httparty'

module ABPlugin
  class API
    include HTTParty
    
    def self.boot(token, url)
      base_uri url
      self.get('/boot.json', :query => { :token => token })
    end
  end
end