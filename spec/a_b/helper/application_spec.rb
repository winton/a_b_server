require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Application do
  describe :helpers do
    
    include Rack::Test::Methods
    
    def app
      Application.new
    end
    
    before(:all) do
      Application.class_eval do
        get '/test_allow' do
          u = allow?
          u ? "#{u.id}" : '0'
        end
        
        get '/test_allow_admin' do
          u = allow_admin?
          u ? "#{u.id}" : '0'
        end
      end
    end
    
    before(:each) do
      teardown_tests
      setup_tests
    end
    
    describe :allow? do
      
      it "should return true if correct token" do
        get('/test_allow', :token => 'token')
        last_response.body.should == '1'
      end
      
      it "should return false if incorrect token" do
        get('/test_allow', :token => 'bad token')
        last_response.body.should == '0'
      end
    end
    
    describe :allow_admin? do
      
      it "should return true if correct token" do
        get('/test_allow_admin', :token => 'token')
        last_response.body.should == '1'
      end
      
      it "should return false if incorrect token" do
        get('/test_allow_admin', :token => 'bad token')
        last_response.body.should == '0'
      end
      
      it "should return false if not admin" do
        u = User.first
        u.admin = false
        u.save
        get('/test_allow_admin', :token => 'token')
        last_response.body.should == '0'
      end
    end
  end
end