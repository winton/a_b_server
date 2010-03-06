require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ABPlugin::Cookies::Cookie do
  
  include Rack::Test::Methods
  
  describe :Rails do
    
    def app
      ActionController::Dispatcher.new
    end
    
    it "should set cookie" do
      get "/set_cookie"
      set_cookie = last_response['Set-Cookie']
      set_cookie.include?('path=/').should == true
      cookie = JSON(CGI::unescape(set_cookie.split('a_b=')[1].split(';')[0]))
      cookie['c'].should == { '1' => 1 }
    end
    
    it "should get cookie" do
      get "/set_cookie"
      get "/get_cookie"
      last_response.body.should == '1'
    end
  end
  
  describe :Sinatra do
    
    def app
      SinatraApp.new
    end
    
    it "should set cookie" do
      get "/set_cookie"
      set_cookie = last_response['Set-Cookie']
      set_cookie.include?('path=/').should == true
      cookie = JSON(CGI::unescape(set_cookie.split('a_b=')[1].split(';')[0]))
      cookie['c'].should == { '1' => 1 }
    end
    
    it "should get cookie" do
      get "/set_cookie"
      get "/get_cookie"
      last_response.body.should == '1'
    end
  end
end
