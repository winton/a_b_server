$testing = true
SPEC = File.dirname(__FILE__)

require 'pp'
require 'cgi'

require 'rubygems'
require 'json'
require 'rack/test'
require 'sinatra/base'

require File.expand_path("#{SPEC}/fixtures/rails/config/environment")
require File.expand_path("#{SPEC}/../rails/init")
require File.expand_path("#{SPEC}/fixtures/sinatra")

Spec::Runner.configure do |config|
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end

def params(url)
  CGI.parse(URI.parse(url).query)
end

def stub_api_boot
  @session_id = 's'*20
  @token = 't'*20
  @url = 'http://test.com'
  @user_token = 'u'*20
  @tests = [{
    "name" => "Test",
    "variants" => [
      {
        "name" => "v1",
        "visits" => 0
      },
      {
        "name" => "v2",
        "visits" => 0
      },
      {
        "name" => "v3",
        "visits" => 0
      }
    ]
  }]
  ABPlugin::API.stub!(:boot).and_return(
    "tests" => @tests,
    "user_token" => @user_token
  )
end