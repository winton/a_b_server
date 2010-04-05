require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ABPlugin::Cookies do
  
  include Rack::Test::Methods
  
  describe :Rails do
    
    def app
      ActionController::Dispatcher.new
    end
    
    it "should set cookie" do
      get "/set_cookie"
      set_cookie = last_response['Set-Cookie']
      set_cookie.include?('path=/').should == true
      set_cookie.split('a_b=')[1].split(';')[0].should == 'test'
    end
    
    it "should get cookie" do
      get "/set_cookie"
      get "/get_cookie"
      last_response.body.should == 'test'
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
      set_cookie.split('a_b=')[1].split(';')[0].should == 'test'
    end
    
    it "should get cookie" do
      get "/set_cookie"
      get "/get_cookie"
      last_response.body.should == 'test'
    end
  end
end
