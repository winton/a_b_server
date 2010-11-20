require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Site do
  
  before(:each) do
    teardown_tests
    setup_tests
  end
  
  describe :associations do
    
    it "should belong to a user" do
      @site.user.nil?.should == false
      @site.user.should == @user
    end
    
    it "should have many categories" do
      @site.categories.empty?.should == false
      @site.categories.should == [ @category ]
    end
    
    it "should destroy categories after destroy" do
      @site.destroy
      Category.count(:conditions => { :user_id => @site.id }).should == 0
    end
    
    it "should have many envs" do
      @site.envs.empty?.should == false
      @site.envs.should == [ @env ]
    end
    
    it "should delete all envs after destroy" do
      @site.destroy
      Env.count(:conditions => { :user_id => @site.id }).should == 0
    end
    
    it "should have many tests" do
      @site.tests.empty?.should == false
      @site.tests.should == [ @test ]
    end
    
    it "should have many variants" do
      @site.variants.empty?.should == false
      @site.variants.should == [ @variant ]
    end
  end
end