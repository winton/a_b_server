require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Env do
  
  before(:each) do
    teardown_tests
    setup_tests
  end
  
  describe :associations do
    
    it "should belong to a site" do
      @env.site.nil?.should == false
      @env.site.should == @site
    end
    
    it "should belong to a user" do
      @env.user.nil?.should == false
      @env.user.should == @user
    end
  end
  
  describe :domain_match? do
    
    it "should return true if match" do
      @env.domain_match?('http://localhost:9393/blah').should == true
      @env.domain_match?('http://test.com').should == true
    end
    
    it "should return false if no match" do
      @env.domain_match?('http://blah.com:9393/blah').should == false
      @env.domain_match?('http://blah.com').should == false
    end
  end
end