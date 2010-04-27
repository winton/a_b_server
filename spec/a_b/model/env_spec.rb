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
  
  describe :names_by_user_id do
    
    it "should return an array of names" do
      Env.names_by_user_id(@user.id).should == [ 'env' ]
    end
  end
end
