require 'spec_helper'

describe ABPlugin do
  
  after(:each) do
    ABPlugin.reset
  end
  
  describe "with no configuration" do
    
    it "should only assign cached_at" do
      ABPlugin.new
      
      ABPlugin.cached_at.to_s.should == (Time.now - 9 * 60).to_s
      ABPlugin.instance.should == nil
      ABPlugin.tests.should == nil
      
      ABPlugin::Config.token.should == nil
      ABPlugin::Config.url.should == nil
    end
    
    it "should not call the API" do
      ABPlugin::API.should_not_receive(:boot)
      ABPlugin.new
    end
  end
  
  describe "with configuration, but no configs exist" do
    
    before(:each) do
      ABPlugin do
        root SPEC + '/does_not_exist'
      end
    end
  
    it "should only assign cached_at" do
      ABPlugin.new

      ABPlugin.cached_at.to_s.should == (Time.now - 9 * 60).to_s
      ABPlugin.instance.should == nil
      ABPlugin.tests.should == nil

      ABPlugin::Config.token.should == nil
      ABPlugin::Config.url.should == nil
    end
  end
  
  describe "when api config config exists" do
    
    before(:each) do
      ABPlugin do
        root SPEC + '/fixtures/api_yaml'
      end
    end
  
    it "should only assign cached_at, token, url" do
      ABPlugin.new
      
      ABPlugin.cached_at.to_s.should == (Time.now - 9 * 60).to_s
      ABPlugin.instance.should == nil
      ABPlugin.tests.should == nil
      
      ABPlugin::Config.token.should == 'token'
      ABPlugin::Config.url.should == 'url'
    end
  end
  
  describe "when cache config exists" do
    
    before(:each) do
      setup_variables
      ABPlugin do
        root SPEC + '/fixtures/cache_yaml'
      end
    end
    
    it "should only assign cached_at and tests" do
      ABPlugin.new
      
      ABPlugin.cached_at.to_s.should == (Time.now - 9 * 60).to_s
      ABPlugin.instance.should == nil
      ABPlugin.tests.should == @tests
      
      ABPlugin::Config.token.should == nil
      ABPlugin::Config.url.should == nil
    end
  end
  
  describe "when api and cache configs exist" do
    
    before(:each) do
      setup_variables
      ABPlugin do
        api_yaml SPEC + '/fixtures/api_yaml/config/a_b/api.yml'
        cache_yaml SPEC + '/fixtures/cache_yaml/config/a_b/cache.yml'
      end
    end
    
    it "should assign everything" do
      ABPlugin.new
      
      ABPlugin.cached_at.to_s.should == Time.now.to_s
      ABPlugin.instance.should == nil
      ABPlugin.tests.should == @tests
      
      ABPlugin::Config.token.should == 'token'
      ABPlugin::Config.url.should == 'url'
    end
  end
  
  describe "when in binary mode" do
    describe "and api config present" do
      
      before(:each) do
        setup_variables
        ABPlugin do
          api_yaml SPEC + '/fixtures/api_yaml/config/a_b/api.yml'
          binary true
        end
      end
      
      it "should call API.get" do
        ABPlugin::API.should_receive(:get).with('/boot.json', :query => { :token => 'token' }).and_return(nil)
        ABPlugin.new
      end
    end
    
    describe "and api config not present" do
      
      before(:each) do
        setup_variables
        ABPlugin do
          binary true
        end
      end
      
      it "should not call API.get" do
        ABPlugin::API.should_not_receive(:get)
        ABPlugin.new
      end
    end
  end
  
  describe :load_yaml? do
    
    it "should be false after first attempt" do
      ABPlugin.new
      ABPlugin.load_yaml?.should == false
    end
  end
end
